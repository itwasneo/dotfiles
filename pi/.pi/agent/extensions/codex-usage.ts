import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { spawn, type ChildProcessWithoutNullStreams } from "node:child_process";
import readline from "node:readline";

const CODEX_BIN = process.env.PI_CODEX_BIN ?? "codex";

type RpcResponse = {
	id?: number;
	result?: any;
	error?: { code?: number; message?: string };
	method?: string;
	params?: any;
};

type RateLimitWindow = {
	usedPercent?: number | null;
	windowDurationMins?: number | null;
	resetsAt?: number | null;
};

type RateLimitBucket = {
	limitId?: string | null;
	limitName?: string | null;
	planType?: string | null;
	primary?: RateLimitWindow | null;
	secondary?: RateLimitWindow | null;
	rateLimitReachedType?: string | null;
};

type RateLimitsResult = {
	rateLimits?: RateLimitBucket | null;
	rateLimitsByLimitId?: Record<string, RateLimitBucket> | null;
	rateLimitResetCredits?: { availableCount?: number | null; credits?: any[] | null } | null;
};

type UsageResult = {
	summary?: {
		lifetimeTokens?: number | null;
		peakDailyTokens?: number | null;
		longestRunningTurnSec?: number | null;
		currentStreakDays?: number | null;
		longestStreakDays?: number | null;
	} | null;
	dailyUsageBuckets?: Array<{ startDate?: string; tokens?: number | null }> | null;
};

class CodexAppServerClient {
	private proc?: ChildProcessWithoutNullStreams;
	private nextId = 1;
	private pending = new Map<number, { resolve: (value: any) => void; reject: (error: Error) => void }>();
	private stderr = "";
	private initialized?: Promise<void>;
	private stopping = false;
	onRateLimitsUpdated?: (result: RateLimitsResult) => void;
	onExit?: () => void;

	async request(method: string, params?: any, timeoutMs = 15_000): Promise<any> {
		await this.ensureStarted();
		return await this.sendRequest(method, params, timeoutMs);
	}

	private async sendRequest(method: string, params?: any, timeoutMs = 15_000): Promise<any> {
		const id = this.nextId++;
		const message = params === undefined ? { method, id } : { method, id, params };

		return await new Promise((resolve, reject) => {
			const timeout = setTimeout(() => {
				this.pending.delete(id);
				reject(new Error(`Timed out waiting for ${method}`));
			}, timeoutMs);

			this.pending.set(id, {
				resolve: (value) => {
					clearTimeout(timeout);
					resolve(value);
				},
				reject: (error) => {
					clearTimeout(timeout);
					reject(error);
				},
			});

			this.proc!.stdin.write(`${JSON.stringify(message)}\n`);
		});
	}

	async ensureStarted(): Promise<void> {
		if (this.initialized) return await this.initialized;

		this.proc = spawn(CODEX_BIN, ["app-server"], { detached: true, stdio: ["pipe", "pipe", "pipe"] });
		this.proc.stderr.on("data", (data) => {
			this.stderr = `${this.stderr}${String(data)}`.slice(-4000);
		});
		this.proc.once("close", () => {
			const error = new Error(this.stderr.trim() || "codex app-server exited");
			for (const entry of this.pending.values()) entry.reject(error);
			this.pending.clear();
			this.proc = undefined;
			this.initialized = undefined;
			const wasStopping = this.stopping;
			this.stopping = false;
			if (!wasStopping) this.onExit?.();
		});

		const rl = readline.createInterface({ input: this.proc.stdout });
		rl.on("line", (line) => this.handleLine(line));

		this.initialized = (async () => {
			await this.sendRequest("initialize", {
				clientInfo: { name: "pi_codex_usage", title: "Pi Codex Usage", version: "0.1.0" },
				capabilities: { experimentalApi: true },
			});
			this.proc!.stdin.write(`${JSON.stringify({ method: "initialized", params: {} })}\n`);
		})();

		return await this.initialized;
	}

	stop() {
		this.stopping = true;
		for (const entry of this.pending.values()) entry.reject(new Error("codex usage extension stopped"));
		this.pending.clear();
		const pid = this.proc?.pid;
		if (pid) {
			try {
				process.kill(-pid, "SIGTERM");
			} catch {
				this.proc?.kill("SIGTERM");
			}
		}
		this.proc = undefined;
		this.initialized = undefined;
	}

	private handleLine(line: string) {
		let message: RpcResponse;
		try {
			message = JSON.parse(line);
		} catch {
			return;
		}

		if (typeof message.id === "number") {
			const pending = this.pending.get(message.id);
			if (!pending) return;
			this.pending.delete(message.id);
			if (message.error) {
				pending.reject(new Error(message.error.message ?? `JSON-RPC error ${message.error.code ?? "unknown"}`));
			} else {
				pending.resolve(message.result);
			}
			return;
		}

		if (message.method === "account/rateLimits/updated") {
			this.onRateLimitsUpdated?.(message.params as RateLimitsResult);
		}
	}
}

function formatRelativeReset(resetsAt?: number | null): string | undefined {
	if (!resetsAt) return undefined;
	const seconds = Math.max(0, resetsAt - Math.floor(Date.now() / 1000));
	const minutes = Math.floor(seconds / 60);
	const hours = Math.floor(minutes / 60);
	if (hours > 0) return `${hours}h ${minutes % 60}m`;
	if (minutes > 0) return `${minutes}m`;
	return `${seconds}s`;
}

function formatNumber(value?: number | null): string {
	return typeof value === "number" ? value.toLocaleString() : "n/a";
}

function getBuckets(result?: RateLimitsResult): RateLimitBucket[] {
	if (!result) return [];
	if (result.rateLimitsByLimitId && Object.keys(result.rateLimitsByLimitId).length > 0) {
		return Object.entries(result.rateLimitsByLimitId)
			.sort(([a], [b]) => (a === "codex" ? -1 : b === "codex" ? 1 : a.localeCompare(b)))
			.map(([, bucket]) => bucket);
	}
	return result.rateLimits ? [result.rateLimits] : [];
}

function formatBucket(bucket: RateLimitBucket): string {
	const name = bucket.limitName || bucket.limitId || "codex";
	const primary = bucket.primary;
	const used = typeof primary?.usedPercent === "number" ? `${Math.round(primary.usedPercent)}%` : "n/a";
	const window = primary?.windowDurationMins ? `${primary.windowDurationMins}m` : "window n/a";
	const reset = formatRelativeReset(primary?.resetsAt);
	const reached = bucket.rateLimitReachedType ? ` · ${bucket.rateLimitReachedType}` : "";
	const plan = bucket.planType ? ` · ${bucket.planType}` : "";
	return `${name}: ${used}/${window}${reset ? ` · reset ${reset}` : ""}${plan}${reached}`;
}

function formatDetails(rateLimits?: RateLimitsResult, usage?: UsageResult, error?: string): string[] {
	const lines = ["Codex / ChatGPT usage"];
	if (error) lines.push(`Error: ${error}`);
	const buckets = getBuckets(rateLimits);
	if (buckets.length > 0) lines.push(...buckets.map(formatBucket));
	const credits = rateLimits?.rateLimitResetCredits?.availableCount;
	if (typeof credits === "number") lines.push(`Earned reset credits: ${credits}`);
	if (usage?.summary) {
		lines.push(`Lifetime tokens: ${formatNumber(usage.summary.lifetimeTokens)}`);
		lines.push(`Peak daily tokens: ${formatNumber(usage.summary.peakDailyTokens)}`);
		lines.push(`Current streak: ${formatNumber(usage.summary.currentStreakDays)} days`);
	}
	if (lines.length === 1) lines.push("No usage data returned yet.");
	return lines;
}

function shortError(error: unknown): string {
	const message = error instanceof Error ? error.message : String(error);
	return message.replace(/\s+/g, " ").slice(0, 220);
}

export default function (pi: ExtensionAPI) {
	const client = new CodexAppServerClient();
	let ctxRef: ExtensionContext | undefined;
	let latestRateLimits: RateLimitsResult | undefined;
	let latestUsage: UsageResult | undefined;
	let latestError: string | undefined;
	let shuttingDown = false;

	async function refresh(ctx = ctxRef, notify = false) {
		if (ctx) ctxRef = ctx;
		try {
			latestRateLimits = (await client.request("account/rateLimits/read")) as RateLimitsResult;
			latestError = undefined;
		} catch (error) {
			latestError = shortError(error);
		}

		try {
			latestUsage = (await client.request("account/usage/read")) as UsageResult;
		} catch (error) {
			// Older Codex versions do not expose account/usage/read. Keep rate-limit data useful.
			if (!latestError && !shortError(error).includes("unknown variant `account/usage/read`")) {
				latestError = shortError(error);
			}
		}

		if (notify && ctx?.hasUI) ctx.ui.notify(formatDetails(latestRateLimits, latestUsage, latestError).join("\n"), latestError ? "warning" : "info");
	}

	client.onRateLimitsUpdated = (result) => {
		latestRateLimits = result;
		latestError = undefined;
	};
	client.onExit = () => {
		if (shuttingDown) return;
		latestError = "codex app-server exited";
	};

	async function showUsage(ctx: ExtensionContext) {
		ctxRef = ctx;
		try {
			await refresh(ctx, true);
		} finally {
			client.stop();
		}
	}

	pi.on("session_start", async (_event, _ctx) => {
		shuttingDown = false;
	});

	pi.on("session_shutdown", async (_event, _ctx) => {
		shuttingDown = true;
		ctxRef = undefined;
		client.stop();
	});

	pi.registerCommand("codex-usage", {
		description: "Show ChatGPT/Codex rate-limit and token usage from codex app-server",
		handler: async (_args, ctx) => showUsage(ctx),
	});

	pi.registerShortcut("pageDown", {
		description: "Show ChatGPT/Codex usage",
		handler: async (ctx) => showUsage(ctx),
	});
}
