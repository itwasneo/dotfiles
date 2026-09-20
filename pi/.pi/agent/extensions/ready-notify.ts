import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const ENABLE_BELL = process.env.PI_READY_NOTIFY_BELL === "1";
const ENABLE_TMUX = process.env.PI_READY_NOTIFY_TMUX !== "0";
const ENABLE_NOTIFY_SEND = process.env.PI_READY_NOTIFY_SEND !== "0";
const ENABLE_SOUND = process.env.PI_READY_NOTIFY_SOUND !== "0";
const TITLE = process.env.PI_READY_NOTIFY_TITLE ?? "Pi agent is ready";
const BODY = process.env.PI_READY_NOTIFY_BODY ?? "";
const ICON = process.env.PI_READY_NOTIFY_ICON ?? "applications-development";
const FOCUS_IN = "\x1b[I";
const FOCUS_OUT = "\x1b[O";

async function commandExists(pi: ExtensionAPI, command: string): Promise<boolean> {
	const result = await pi.exec("sh", ["-lc", `command -v ${command} >/dev/null 2>&1`]).catch(() => undefined);
	return result?.code === 0;
}

export default function (pi: ExtensionAPI) {
	let terminalFocused = true;
	let terminalInputUnsubscribe: (() => void) | undefined;

	pi.on("session_start", async (_event, ctx) => {
		terminalFocused = true;
		terminalInputUnsubscribe?.();

		if (ctx.mode === "tui") {
			// Ask terminals to report focus changes. In tmux, this also needs:
			//   set -g focus-events on
			process.stdout.write("\x1b[?1004h");
			terminalInputUnsubscribe = ctx.ui.onTerminalInput((data) => {
				if (data.includes(FOCUS_IN)) terminalFocused = true;
				if (data.includes(FOCUS_OUT)) terminalFocused = false;
			});
		}
	});

	pi.on("agent_settled", async (_event, ctx) => {
		if (!ctx.isIdle()) return;
		if (terminalFocused) return;

		if (ENABLE_NOTIFY_SEND && (await commandExists(pi, "notify-send"))) {
			const args = ["--app-name=Pi", "--urgency=normal", `--icon=${ICON}`, TITLE];
			if (BODY) args.push(BODY);
			await pi.exec("notify-send", args).catch(() => undefined);
		}

		if (ENABLE_SOUND && (await commandExists(pi, "canberra-gtk-play"))) {
			await pi.exec("canberra-gtk-play", ["--id", "message-new-instant", "--description", TITLE]).catch(() => undefined);
		}

		if (ENABLE_TMUX && process.env.TMUX) {
			await pi.exec("tmux", ["display-message", TITLE]).catch(() => undefined);
		}

		if (ENABLE_BELL) process.stderr.write("\x07");
	});

	pi.on("session_shutdown", async () => {
		terminalInputUnsubscribe?.();
		terminalInputUnsubscribe = undefined;
		process.stdout.write("\x1b[?1004l");
	});
}
