#!/usr/bin/env bash
# tests/security/test_inbound_filter.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
FILTER="$SCRIPT_DIR/../../skills/osint-research/lib/inbound-filter.sh"

echo "== test_inbound_filter =="

# URL host match
input='{"url":"https://pastebin.com/abc","content":"x"}'
got=$(printf '%s' "$input" | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "blocklisted url host dropped"

# Subdomain of blocklisted host
input='{"url":"https://archive.dehashed.com/x","content":"x"}'
got=$(printf '%s' "$input" | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "blocklisted subdomain dropped"

# Content body reference
input='{"url":"https://safe.com/x","content":"see leak at doxbin.org/abc"}'
got=$(printf '%s' "$input" | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "content body reference dropped"

# Extension via env var
input='{"url":"https://customblock.test/x","content":"x"}'
got=$(printf '%s' "$input" | OSINT_EXTRA_BLOCKLIST="customblock.test" bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "extra blocklist works"

assert_summary
