#!/usr/bin/env bash
# tests/channels/test_github-leaks.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
GL="$SCRIPT_DIR/../../skills/osint-research/channels/github-leaks.sh"

echo "== test_github-leaks =="

fixture='{"items":[{"path":"config/dev.env","html_url":"https://github.com/example-corp/legacy/blob/abc/config/dev.env","repository":{"full_name":"example-corp/legacy"},"text_matches":[{"fragment":"AWS_KEY=AKIAIOSFODNN7EXAMPLE\nDB_PASS=secret123"}]}]}'
got=$(bash "$GL" --type domain --target example-corp.com --fixture <(printf '%s' "$fixture"))

assert_contains "$got" "AKIA...MPLE" "aws key redacted in output"
assert_not_contains "$got" "AKIAIOSFODNN7EXAMPLE" "plaintext aws key NOT in output"
assert_contains "$got" "example-corp/legacy" "repo path retained"
assert_contains "$got" '"channel":"github-leaks"' "channel label"
assert_contains "$got" '"record_type":"code_match"' "record type"

assert_summary
