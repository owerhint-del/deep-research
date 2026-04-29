#!/usr/bin/env bash
# skills/osint-research/channels/github-leaks.sh
# GitHub code search → emits NDJSON, redacted via secret-redactor.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REDACT="$SCRIPT_DIR/../lib/secret-redactor.sh"

ENTITY_TYPE=""
TARGET=""
FIXTURE=""
while [ $# -gt 0 ]; do
    case "$1" in
        --type) ENTITY_TYPE="$2"; shift 2;;
        --target) TARGET="$2"; shift 2;;
        --fixture) FIXTURE="$2"; shift 2;;
        *) echo "github-leaks: unknown flag: $1" >&2; exit 1;;
    esac
done

[ -z "$TARGET" ] && { echo "github-leaks: empty target" >&2; exit 1; }

if [ -n "$FIXTURE" ]; then
    json=$(cat "$FIXTURE")
elif command -v gh >/dev/null; then
    json=$(gh api -X GET "search/code" -f q="$TARGET" --jq . 2>/dev/null || echo "{}")
else
    json="{}"
fi

# Plan defect #1 fix: heredoc + pipe conflict — write script to tmp file instead.
_py_tmp=$(mktemp)
trap 'rm -f "$_py_tmp"' EXIT
cat > "$_py_tmp" <<'PY'
import json, sys
target = sys.argv[1]
try:
    data = json.loads(sys.stdin.read())
except Exception:
    sys.exit(0)
SEP = (',', ':')  # Plan defect #2 fix: compact JSON to match test assertions.
for item in data.get("items", []):
    repo = (item.get("repository") or {}).get("full_name", "")
    path = item.get("path", "")
    url = item.get("html_url", "")
    fragments = item.get("text_matches") or []
    if not fragments:
        fragments = [{"fragment": ""}]
    for f in fragments:
        body = f.get("fragment", "")
        out = {
            "channel": "github-leaks",
            "record_type": "code_match",
            "url": url,
            "content": body,
            "metadata": {"target": target, "repo": repo, "path": path}
        }
        print(json.dumps(out, separators=SEP))
PY
# Pipeline: json input → python parses → emits NDJSON → redactor scrubs secrets.
# Redactor is the security boundary for github-derived data.
printf '%s' "$json" | python3 "$_py_tmp" "$TARGET" | bash "$REDACT"
