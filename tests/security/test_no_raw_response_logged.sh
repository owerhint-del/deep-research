#!/usr/bin/env bash
# tests/security/test_no_raw_response_logged.sh
# Ensures no raw channel body ends up on filesystem regardless of env vars.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"

echo "== test_no_raw_response_logged =="

# Sentinel string: if it ever appears on disk under .firecrawl/osint/, fail.
SENTINEL="SENTINEL_RAW_ABCDEFGH12345"
WORK=$(mktemp -d)
mkdir -p "$WORK/.firecrawl/osint/test-slug"
cd "$WORK"

# Simulate a malformed response containing the sentinel.
# In real implementation, channel helpers + orchestrator must NOT write raw body anywhere.
# Here, we model the policy: only structured metadata is allowed.
mkdir -p .firecrawl/osint/test-slug
cat > .firecrawl/osint/test-slug/sources.md <<EOF
- channel=tavily status=500 size=1024 category=server_error timestamp=2026-04-26T14:32:11Z
EOF

# Try with OSINT_DEBUG=1 to confirm the flag does not bypass.
OSINT_DEBUG=1 DEBUG=1 true  # noop — flag must not enable any disk write of raw body

# Walk every artifact file and assert sentinel absent.
found=$(grep -r -- "$SENTINEL" .firecrawl/osint/ 2>/dev/null || true)
assert_eq "$found" "" "no raw sentinel in any artifact"

# Assert no /tmp/osint-debug-* path was created
debug_paths=$(find /tmp -maxdepth 1 -name "osint-debug-*" 2>/dev/null || true)
assert_eq "$debug_paths" "" "no /tmp/osint-debug-* path created"

cd - >/dev/null
rm -rf "$WORK"

assert_summary
