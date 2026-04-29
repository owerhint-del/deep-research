#!/usr/bin/env bash
# tests/security/test_no_plaintext_secrets.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"

echo "== test_no_plaintext_secrets =="
REDACT="$SCRIPT_DIR/../../skills/osint-research/lib/secret-redactor.sh"

# Seed a fixture with every known secret pattern, run through redactor,
# verify none of the seeded values appear verbatim in the output.
SEEDS=(
    "AKIAIOSFODNN7EXAMPLE"
    "ghp_abcdefghijklmnopqrstuvwxyz0123456789"
    "<TEST-FIXTURE-SLACK-TOKEN>"
    "<TEST-FIXTURE-STRIPE-KEY>"
    "<TEST-FIXTURE-TWILIO-SID>"
    "AIzaSyAbcdefghijklmnopqrstuvwxyz1234567"
)

INPUT=""
for s in "${SEEDS[@]}"; do INPUT="$INPUT seed=$s "; done
got=$(printf '%s' "$INPUT" | bash "$REDACT")

for s in "${SEEDS[@]}"; do
    assert_not_contains "$got" "$s" "seeded $s NOT in output"
done

assert_summary
