#!/usr/bin/env bash
# tests/channels/test_whois-dns.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
WD="$SCRIPT_DIR/../../skills/osint-research/channels/whois-dns.sh"

echo "== test_whois-dns =="

# example.com is RFC reserved and stable. Allow integration test to skip if no network.
if ! command -v whois >/dev/null || ! command -v dig >/dev/null; then
    echo "  SKIP: whois/dig missing"
    assert_summary
    exit 0
fi

got=$(bash "$WD" --type domain --target example.com 2>/dev/null || true)
assert_contains "$got" "example.com" "result references target"
assert_contains "$got" '"channel":"whois-dns"' "channel label present"
assert_contains "$got" '"record_type"' "structured records"

# Invalid input
bash "$WD" --type domain --target "" >/dev/null 2>&1
assert_exit_code 1 $? "empty target fails"

# --- Fix #2 — no whois record when whois output is empty ---
# Use a known-non-existent TLD to force whois to return empty.
got=$(bash "$WD" --type domain --target nonexistent.invalidtld 2>/dev/null || true)
# Either no whois record (preferred) or the channel emits dig records but no
# empty-content whois record. Assert no record with empty content field for whois.
assert_not_contains "$got" '"channel":"whois-dns","record_type":"whois","url":"whois://nonexistent.invalidtld","content":""' "no empty-whois record emitted"

assert_summary
