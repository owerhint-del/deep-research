#!/usr/bin/env bash
# tests/channels/test_shodan-idb.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
SH="$SCRIPT_DIR/../../skills/osint-research/channels/shodan-idb.sh"

echo "== test_shodan-idb =="

fixture='{"ip":"1.2.3.4","ports":[80,443,6379],"cpes":["cpe:nginx:1.14"],"hostnames":["cache.example-corp.com"],"tags":[],"vulns":["CVE-2021-23017"]}'
got=$(bash "$SH" --target 1.2.3.4 --fixture <(printf '%s' "$fixture"))

assert_contains "$got" '"port":80' "port 80 reported"
assert_contains "$got" '"port":6379' "port 6379 reported (notable)"
assert_contains "$got" 'CVE-2021-23017' "CVE reported"
assert_contains "$got" 'cache.example-corp.com' "hostname reported"
assert_contains "$got" '"channel":"shodan-idb"' "channel label"

# 404 fixture (no data on this IP — normal, not error)
fixture404='{"detail":"No information available"}'
got404=$(bash "$SH" --target 9.9.9.9 --fixture <(printf '%s' "$fixture404") --fixture-status 404)
# Should emit nothing (no data is normal)
assert_eq "$got404" "" "404 produces no output"

assert_summary
