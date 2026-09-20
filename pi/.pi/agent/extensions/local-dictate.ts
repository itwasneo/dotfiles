import {
	CustomEditor,
	type ExtensionAPI,
	type ExtensionContext,
	type KeybindingsManager,
} from "@earendil-works/pi-coding-agent";
import type { EditorTheme, TUI } from "@earendil-works/pi-tui";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import { existsSync } from "node:fs";
import { readdir, stat, unlink } from "node:fs/promises";
import { homedir, tmpdir } from "node:os";
import { join } from "node:path";
import { spawn, type ChildProcessWithoutNullStreams } from "node:child_process";

const WHISPER =
	process.env.PI_DICTATE_WHISPER ?? join(homedir(), "git/whisper.cpp/build/bin/whisper-cli");
const MODEL = process.env.PI_DICTATE_MODEL ?? join(homedir(), "git/whisper.cpp/models/ggml-base.en.bin");
// Default to PipeWire's ALSA plugin instead of opening the HyperX hardware
// device directly. Direct `plughw:*` capture is exclusive and now often fails
// with "Device or resource busy" when PipeWire already owns the mic. Override
// with PI_DICTATE_ARECORD_DEVICE if you need a specific ALSA device.
const ARECORD_DEVICE = process.env.PI_DICTATE_ARECORD_DEVICE ?? "pipewire";
const WAV_PREFIX = "pi-dictate-";

type Recording = {
	proc: ChildProcessWithoutNullStreams;
	wav: string;
	startedAt: number;
	stderr: string;
};

async function cleanupStaleRecordings() {
	const dir = tmpdir();
	const files = await readdir(dir).catch(() => []);
	await Promise.all(
		files
			.filter((file) => file.startsWith(WAV_PREFIX) && file.endsWith(".wav"))
			.map((file) => unlink(join(dir, file)).catch(() => {})),
	);
}

function cleanTranscript(stdout: string): string {
	return stdout
		.split("\n")
		.map((line) => line.trim())
		.filter((line) => line && line !== "[ Silence ]" && line !== "[BLANK_AUDIO]")
		.join(" ")
		.replace(/\s+/g, " ")
		.trim();
}

function waitForExit(proc: ChildProcessWithoutNullStreams, timeoutMs = 3000): Promise<number | null> {
	if (proc.exitCode !== null) return Promise.resolve(proc.exitCode);
	if (proc.signalCode !== null) return Promise.resolve(null);
	return new Promise((resolve) => {
		let done = false;
		let killTimeout: ReturnType<typeof setTimeout> | undefined;
		const finish = (code: number | null) => {
			if (done) return;
			done = true;
			clearTimeout(timeout);
			if (killTimeout) clearTimeout(killTimeout);
			resolve(code);
		};

		const timeout = setTimeout(() => {
			proc.kill("SIGTERM");
			killTimeout = setTimeout(() => {
				proc.kill("SIGKILL");
				finish(null);
			}, 1000);
		}, timeoutMs);

		proc.once("close", (code) => finish(code));
	});
}

async function hasRecordedAudio(wav: string): Promise<boolean> {
	const info = await stat(wav).catch(() => undefined);
	// A bare WAV header is usually 44 bytes. Anything larger means arecord wrote audio.
	return !!info && info.size > 44;
}

function fitBorder(
	left: string,
	right: string,
	width: number,
	border: (text: string) => string,
	fill: (text: string) => string = border,
): string {
	if (width <= 0) return "";
	if (width === 1) return border("─");

	let leftText = left;
	let rightText = right;
	const fixedWidth = 2;
	const minimumGap = 3;

	while (fixedWidth + visibleWidth(leftText) + visibleWidth(rightText) + minimumGap > width && visibleWidth(rightText) > 0) {
		rightText = truncateToWidth(rightText, Math.max(0, visibleWidth(rightText) - 1), "");
	}
	while (fixedWidth + visibleWidth(leftText) + visibleWidth(rightText) + minimumGap > width && visibleWidth(leftText) > 0) {
		leftText = truncateToWidth(leftText, Math.max(0, visibleWidth(leftText) - 1), "");
	}

	const gapWidth = Math.max(0, width - fixedWidth - visibleWidth(leftText) - visibleWidth(rightText));
	return `${border("─")}${leftText}${fill("─".repeat(gapWidth))}${rightText}${border("─")}`;
}

export default function (pi: ExtensionAPI) {
	let recording: Recording | undefined;
	let statusTimer: ReturnType<typeof setInterval> | undefined;
	let activeTui: TUI | undefined;
	let dictateStatus: { label: string; frames: string[]; color: "error" | "success"; frame: number } | undefined;
	let terminalInputUnsubscribe: (() => void) | undefined;
	const pendingInsertTimers = new Set<ReturnType<typeof setTimeout>>();
	const recordingSpinner = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];
	const transcribingSpinner = [">", ">>", ">>>"];

	function startStatus(_ctx: ExtensionContext, label: string, frames: string[], color: "error" | "success", intervalMs = 100) {
		if (statusTimer) clearInterval(statusTimer);
		dictateStatus = { label, frames, color, frame: 0 };
		statusTimer = setInterval(() => {
			if (!dictateStatus) return;
			dictateStatus.frame = (dictateStatus.frame + 1) % dictateStatus.frames.length;
			activeTui?.requestRender();
		}, intervalMs);
		activeTui?.requestRender();
	}

	function stopStatus(_ctx: ExtensionContext) {
		if (statusTimer) {
			clearInterval(statusTimer);
			statusTimer = undefined;
		}
		dictateStatus = undefined;
		activeTui?.requestRender();
	}

	function scheduleTranscriptInsert(ctx: ExtensionContext, text: string) {
		// Slash command handling can reset the editor after the command handler
		// finishes. Defer insertion to the next TUI turn so `/dictate stop` and
		// shortcut toggles both leave the transcript visible in the prompt editor.
		const timer = setTimeout(() => {
			pendingInsertTimers.delete(timer);
			const existing = ctx.ui.getEditorText?.() ?? "";
			ctx.ui.setEditorText(existing ? `${existing} ${text}` : text);
			ctx.ui.notify("Dictation inserted", "info");
		}, 25);
		pendingInsertTimers.add(timer);
	}

	async function startRecording(ctx: ExtensionContext) {
		if (ctx.mode !== "tui") {
			ctx.ui.notify("Dictation requires interactive mode", "error");
			return;
		}

		if (!existsSync(WHISPER)) {
			ctx.ui.notify(`Missing whisper binary: ${WHISPER}`, "error");
			return;
		}

		if (!existsSync(MODEL)) {
			ctx.ui.notify(`Missing whisper model: ${MODEL}`, "error");
			return;
		}

		const wav = join(tmpdir(), `${WAV_PREFIX}${process.pid}-${Date.now()}.wav`);
		const args = [
			...(ARECORD_DEVICE ? ["-D", ARECORD_DEVICE] : []),
			"-f",
			"S16_LE",
			"-r",
			"16000",
			"-c",
			"1",
			wav,
		];

		const proc = spawn("arecord", args, { stdio: ["ignore", "pipe", "pipe"] });
		recording = { proc, wav, startedAt: Date.now(), stderr: "" };

		proc.stderr.on("data", (chunk) => {
			if (recording?.proc === proc) recording.stderr += String(chunk);
		});

		proc.once("error", async (error) => {
			if (recording?.proc !== proc) return;
			recording = undefined;
			stopStatus(ctx);
			await unlink(wav).catch(() => {});
			ctx.ui.notify(`Recording failed: ${error.message}`, "error");
		});

		proc.once("exit", async (code, signal) => {
			if (recording?.proc !== proc) return;

			// If arecord exits while `recording` still points at it, this was not a
			// user-requested stop. Always clear the active recording and remove the
			// temp WAV in this path. arecord returns code 1 for a normal SIGINT stop,
			// but stopAndTranscribe() clears `recording` before sending SIGINT, so this
			// handler is inactive for requested stops.
			const stderr = recording.stderr;
			recording = undefined;
			stopStatus(ctx);
			await unlink(wav).catch(() => {});
			ctx.ui.notify(`Recording failed: ${stderr || `arecord exited ${code ?? signal ?? "unexpectedly"}`}`, "error");
		});

		startStatus(ctx, "RED MEANS RECORDING", recordingSpinner, "error");
		ctx.ui.notify(`Recording started on ${ARECORD_DEVICE || "default device"}. Run /dictate stop when finished.`, "info");
	}

	async function stopAndTranscribe(ctx: ExtensionContext) {
		const current = recording;
		if (!current) {
			await startRecording(ctx);
			return;
		}

		recording = undefined;
		stopStatus(ctx);

		try {
			const elapsed = Math.max(1, Math.round((Date.now() - current.startedAt) / 1000));
			ctx.ui.notify(`Stopping recording (${elapsed}s)...`, "info");
			current.proc.kill("SIGINT");
			const code = await waitForExit(current.proc);

			if (code !== null && code !== 0 && code !== 1 && code !== 130 && code !== 143) {
				ctx.ui.notify(`Recording failed: ${current.stderr || `arecord exited ${code}`}`, "error");
				return;
			}

			if (!(await hasRecordedAudio(current.wav))) {
				ctx.ui.notify(`Recording failed: ${current.stderr || "no audio was written"}`, "error");
				return;
			}

			startStatus(ctx, "", transcribingSpinner, "success", 250);
			ctx.ui.notify("Transcribing locally...", "info");
			const out = await pi.exec(WHISPER, ["-m", MODEL, "-f", current.wav, "-nt", "-np"]);

			if (out.code !== 0) {
				ctx.ui.notify(`Whisper failed: ${out.stderr || out.stdout}`, "error");
				return;
			}

			const text = cleanTranscript(out.stdout);
			if (!text) {
				ctx.ui.notify("No speech detected", "error");
				return;
			}

			scheduleTranscriptInsert(ctx, text);
		} catch (error) {
			ctx.ui.notify(`Dictation error: ${error instanceof Error ? error.message : String(error)}`, "error");
		} finally {
			stopStatus(ctx);
			await unlink(current.wav).catch(() => {});
		}
	}

	async function cancelRecording() {
		const current = recording;
		if (!current) return;
		recording = undefined;
		current.proc.kill("SIGINT");
		await waitForExit(current.proc).catch(() => null);
		await unlink(current.wav).catch(() => {});
	}

	async function toggle(ctx: ExtensionContext) {
		if (recording) await stopAndTranscribe(ctx);
		else await startRecording(ctx);
	}

	pi.on("session_start", async (_event, ctx) => {
		await cleanupStaleRecordings();

		if (ctx.mode === "tui") {
			class DictateStatusEditor extends CustomEditor {
				constructor(tui: TUI, theme: EditorTheme, keybindings: KeybindingsManager) {
					super(tui, theme, keybindings);
					activeTui = tui;
				}

				protected renderTopBorder(width: number, hiddenLineCount: number): string {
					if (!dictateStatus) return super.renderTopBorder(width, hiddenLineCount);

					const frame = dictateStatus.frames[dictateStatus.frame] ?? "";
					const label = dictateStatus.label ? `${frame} ${dictateStatus.label}` : frame;
					const topLeft = ctx.ui.theme.fg(dictateStatus.color, ` ${label} `);
					return fitBorder(topLeft, "", width, (text: string) => this.borderColor(text));
				}
			}

			ctx.ui.setEditorComponent((tui, theme, keybindings) => new DictateStatusEditor(tui, theme, keybindings));
		}

		// `registerShortcut("home")` is no longer reliable because Home is also
		// a built-in editor/transcript navigation key. Listen to the raw terminal
		// escape sequences as a fallback so the old dictation key keeps working.
		terminalInputUnsubscribe?.();
		if (ctx.mode === "tui") {
			terminalInputUnsubscribe = ctx.ui.onTerminalInput((data) => {
				if (data !== "\u001b[H" && data !== "\u001b[1~" && data !== "\u001bOH") return;
				void toggle(ctx);
				return { consume: true };
			});
		}
	});

	pi.on("session_shutdown", async (_event, ctx) => {
		terminalInputUnsubscribe?.();
		terminalInputUnsubscribe = undefined;
		activeTui = undefined;
		for (const timer of pendingInsertTimers) clearTimeout(timer);
		pendingInsertTimers.clear();
		stopStatus(ctx);
		ctx.ui.setEditorComponent(undefined);
		await cancelRecording();
	});

	pi.registerCommand("dictate", {
		description: "Toggle local voice dictation. Usage: /dictate [stop]",
		handler: async (args, ctx) => {
			if (args.trim() === "stop") await stopAndTranscribe(ctx);
			else if (recording) await stopAndTranscribe(ctx);
			else await startRecording(ctx);
		},
	});

	pi.registerShortcut("home", {
		description: "Toggle local voice dictation",
		handler: toggle,
	});

	pi.registerShortcut("ctrl+shift+d", {
		description: "Toggle local voice dictation",
		handler: toggle,
	});
}
