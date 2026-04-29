#!/usr/bin/env bash
# tests/security/test_dorks_outbound_blocklist.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
DORKS="$SCRIPT_DIR/../../skills/osint-research/channels/dorks.sh"

echo "== test_dorks_outbound_blocklist =="

for host in pastebin.com dehashed.com breached.cc doxbin.com ddosecrets.com nulled.to; do
    bash "$DORKS" --type domain --target "$host" >/dev/null 2>&1
    assert_exit_code 2 $? "blocked direct target: $host"
    bash "$DORKS" --type domain --target example.com --extra-site "$host" >/dev/null 2>&1
    assert_exit_code 2 $? "blocked --extra-site: $host"
done

assert_summary
