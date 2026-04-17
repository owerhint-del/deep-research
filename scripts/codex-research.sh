#!/usr/bin/env bash
# =====================================================================
# codex-research.sh — fault-tolerant Codex CLI wrapper for research skills
# =====================================================================
#
# Thin, robust wrapper around `codex exec` for use as the optional
# cross-model research channel in L2+ skills. Designed to NEVER block
# the calling pipeline — on any failure (not installed, auth expired,
# rate-limited, timeout) it writes a machine-readable status and exits.
#
# Usage:
#   codex-research.sh <timeout_secs> <output_file> <prompt>
#
# Arguments:
#   timeout_secs  — hard deadline for the Codex call (e.g. 180)
#   output_file   — where to write Codex's markdown output
#   prompt        — the research prompt (remember to quote it)
#
# Environment:
#   DEEP_RESEARCH_DISABLE_CODEX=1  — user opt-out, skill skips Codex call
#
# Exit codes (so the caller can route the flow):
#   0    — success, output_file written
#   124  — timeout exceeded
#   125  — disabled via env
#   126  — Codex CLI not installed
#   127  — Codex auth expired / not logged in
#   other— whatever codex exec returned
#
# Side effects:
#   - Writes "<output_file>.status" with a one-line human-readable status.
#   - On success, output_file contains Codex's response as markdown.
#   - On any failure, output_file is removed so callers can't accidentally
#     synthesize from partial / empty content.
#
# =====================================================================

set -u

TIMEOUT_SECS="${1:-180}"
OUTPUT_FILE="${2:-}"
PROMPT="${3:-}"

if [ -z "$OUTPUT_FILE" ] || [ -z "$PROMPT" ]; then
    echo "Usage: codex-research.sh <timeout_secs> <output_file> <prompt>" >&2
    exit 2
fi

STATUS_FILE="${OUTPUT_FILE}.status"

mkdir -p "$(dirname "$OUTPUT_FILE")"

write_status() {
    echo "$1" | tee "$STATUS_FILE" >&2
}

# --- 1. Opt-out check ---
if [ -n "${DEEP_RESEARCH_DISABLE_CODEX:-}" ]; then
    write_status "SKIPPED: Codex disabled via DEEP_RESEARCH_DISABLE_CODEX"
    exit 125
fi

# --- 2. Installation check ---
if ! command -v codex >/dev/null 2>&1; then
    write_status "SKIPPED: Codex CLI not installed (see docs/CODEX_INTEGRATION.md)"
    exit 126
fi

# --- 3. Pick timeout mechanism (macOS has no native 'timeout') ---
run_timed() {
    local secs="$1"; shift
    if command -v timeout >/dev/null 2>&1; then
        timeout "$secs" "$@"
    elif command -v gtimeout >/dev/null 2>&1; then
        gtimeout "$secs" "$@"
    elif command -v perl >/dev/null 2>&1; then
        # perl -e 'alarm N; exec @ARGV' — universal fallback, available on all unix
        perl -e 'alarm shift; exec @ARGV' "$secs" "$@"
    else
        # No timeout available — run unbounded (Codex itself has soft caps)
        "$@"
    fi
}

# --- 4. Capture stderr so we can detect auth/rate-limit issues ---
STDERR_FILE=$(mktemp)
trap 'rm -f "$STDERR_FILE"' EXIT

# --- 5. Invoke Codex ---
run_timed "$TIMEOUT_SECS" codex exec \
    -c 'web_search="live"' \
    --sandbox read-only \
    --skip-git-repo-check \
    --ephemeral \
    -o "$OUTPUT_FILE" \
    "$PROMPT" \
    2>"$STDERR_FILE"

EXIT=$?

# --- 5b. Always preserve full stderr as .log for diagnostics ---
# Even on timeout or auth failure, this log shows which stage Codex reached
# (startup, auth, search, synthesis). Critical for debugging timeouts.
cp "$STDERR_FILE" "${OUTPUT_FILE}.log" 2>/dev/null || true

# --- 6. Classify outcome ---
STDERR_CONTENT=$(cat "$STDERR_FILE" 2>/dev/null || true)

# 6a. SUCCESS comes FIRST. If Codex exited cleanly AND produced non-trivial
#     output, trust that output — don't let noisy stderr warnings (e.g. the
#     MCP transport token-refresh noise Codex 0.120 emits in the background)
#     cause us to throw away valid research results.
if [ "$EXIT" -eq 0 ] && [ -s "$OUTPUT_FILE" ]; then
    SIZE=$(wc -c < "$OUTPUT_FILE" | tr -d ' ')
    if [ -n "$STDERR_CONTENT" ]; then
        # Preserve stderr for debugging but don't fail on it
        cp "$STDERR_FILE" "${OUTPUT_FILE}.stderr" 2>/dev/null || true
        write_status "SUCCESS: Codex wrote ${SIZE} bytes (stderr saved to .stderr for reference)"
    else
        write_status "SUCCESS: Codex wrote ${SIZE} bytes to $OUTPUT_FILE"
    fi
    exit 0
fi

# 6b. Timeout — check exit code directly (124 = GNU/BSD timeout, 142 = SIGALRM from perl)
if [ "$EXIT" -eq 124 ] || [ "$EXIT" -eq 142 ]; then
    write_status "TIMEOUT: Codex exceeded ${TIMEOUT_SECS}s limit"
    rm -f "$OUTPUT_FILE"
    exit 124
fi

# 6c. Auth failure — only considered when Codex ACTUALLY failed (non-zero exit or empty output)
#     and stderr points clearly to auth issues in the primary flow (not MCP transport noise)
if [ "$EXIT" -ne 0 ] || [ ! -s "$OUTPUT_FILE" ]; then
    if echo "$STDERR_CONTENT" | grep -qiE '401 Unauthorized|not authenticated|auth.*expired|please.*login|not logged in'; then
        write_status "AUTH_FAILED: Codex auth expired — run 'codex auth login' to refresh"
        rm -f "$OUTPUT_FILE"
        exit 127
    fi

    # 6d. Rate limit
    if echo "$STDERR_CONTENT" | grep -qiE 'rate.?limit|quota.*exceeded|429|too many requests'; then
        write_status "RATE_LIMITED: Codex rate-limit hit — skill will continue single-model"
        rm -f "$OUTPUT_FILE"
        exit 128
    fi
fi

# --- 7. Generic failure ---
write_status "FAILED: Codex exit ${EXIT}, output empty or missing. Stderr head: $(echo "$STDERR_CONTENT" | head -2 | tr '\n' ' ')"
rm -f "$OUTPUT_FILE"
exit "$EXIT"
