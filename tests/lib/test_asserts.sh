#!/usr/bin/env bash
# tests/lib/test_asserts.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/asserts.sh"

echo "== test_asserts =="
assert_eq "foo" "foo" "equal strings pass"
assert_contains "hello world" "world" "substring found"
assert_not_contains "hello world" "xyz" "substring absent"
assert_exit_code 0 0 "zero exit"

assert_summary
