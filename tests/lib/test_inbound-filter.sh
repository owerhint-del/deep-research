#!/usr/bin/env bash
# tests/lib/test_inbound-filter.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/asserts.sh"
FILTER="$SCRIPT_DIR/../../skills/osint-research/lib/inbound-filter.sh"

echo "== test_inbound-filter =="

input='{"url":"https://example.com/page","content":"hello"}
{"url":"https://pastebin.com/abc123","content":"leak"}
{"url":"https://archive.pastebin.com/xyz","content":"leak2"}
{"url":"https://example.com/x","content":"go to dehashed.com for more"}
{"url":"https://safe.com/y","content":"plain content"}'

got_stdout=$(printf '%s' "$input" | bash "$FILTER" 2>/tmp/inbound-filter-err)
got_stderr=$(cat /tmp/inbound-filter-err)
rm -f /tmp/inbound-filter-err

assert_contains "$got_stdout" "example.com/page" "clean url passes"
assert_contains "$got_stdout" "safe.com/y" "another clean url passes"
assert_not_contains "$got_stdout" "pastebin.com/abc123" "blocklisted host dropped"
assert_not_contains "$got_stdout" "archive.pastebin.com" "blocklisted subdomain dropped"
assert_not_contains "$got_stdout" "dehashed.com for more" "blocklisted ref in content dropped"
assert_contains "$got_stderr" "filtered=3" "filter count reported"

# --- Fix #1 — malformed OSINT_EXTRA_BLOCKLIST does not disable filter ---
# Inject a token containing regex metacharacters. The filter MUST still block
# hardcoded defaults (pastebin.com).
got_stdout=$(printf '%s' '{"url":"https://pastebin.com/x","content":"y"}' \
    | OSINT_EXTRA_BLOCKLIST='evil.com; echo PWNED' bash "$FILTER" 2>/tmp/inbound-filter-err2)
got_stderr=$(cat /tmp/inbound-filter-err2)
rm -f /tmp/inbound-filter-err2
assert_eq "$got_stdout" "" "malformed extra-blocklist still blocks pastebin"
assert_contains "$got_stderr" "filtered=1" "malformed extra-blocklist reports filter count"

# --- Fix #2 — userinfo URLs are still blocked by host pattern ---
got_stdout=$(printf '%s' '{"url":"https://user:pass@pastebin.com/x","content":"y"}' \
    | bash "$FILTER" 2>/tmp/inbound-filter-err3)
got_stderr=$(cat /tmp/inbound-filter-err3)
rm -f /tmp/inbound-filter-err3
assert_eq "$got_stdout" "" "userinfo URL with blocklisted host is dropped"
assert_contains "$got_stderr" "filtered=1" "userinfo URL filter count"

assert_summary
