#!/usr/bin/env bash
# tests/smoke/dead-domain.sh
# Verifies skill gracefully handles a domain with no DNS / no certs / no wayback / etc.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
ROOT="$SCRIPT_DIR/../.."

echo "== smoke: dead-domain =="

# Use a deliberately invalid domain. Channels should exit cleanly (not crash).
DEAD="invalid-test-domain-xyz-9999.invalid"

# Classifier still returns domain
got=$(bash "$ROOT/skills/osint-research/lib/entity-classifier.sh" "$DEAD")
assert_eq "$got" "domain" "dead domain still classifies"

# crtsh with empty fixture → no output, no crash
empty='[]'
got=$(bash "$ROOT/skills/osint-research/channels/crtsh.sh" --type domain --target "$DEAD" --fixture <(printf '%s' "$empty"))
assert_eq "$got" "" "empty crt.sh produces no output"

# wayback with empty fixture → no output, no crash
empty_wb='{"archived_snapshots":{}}'
got=$(bash "$ROOT/skills/osint-research/channels/wayback.sh" --type domain --target "$DEAD" --fixture <(printf '%s' "$empty_wb"))
assert_eq "$got" "" "empty wayback produces no output"

# shodan-idb with 404 fixture → no output, exit 0
got=$(bash "$ROOT/skills/osint-research/channels/shodan-idb.sh" --target 1.2.3.4 --fixture <(printf '{"detail":"No information"}') --fixture-status 404)
assert_eq "$got" "" "shodan-idb 404 produces no output"

assert_summary
