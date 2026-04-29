#!/usr/bin/env bash
# tests/lib/asserts.sh — plain-bash assertion helpers for OSINT tests.
# Source this from any test_*.sh script.

set -uo pipefail

# Counters used by test scripts that source this helper.
ASSERT_PASS=0
ASSERT_FAIL=0

_RED=$'\033[31m'
_GREEN=$'\033[32m'
_RESET=$'\033[0m'

assert_eq() {
    local got="$1" want="$2" label="${3:-assert_eq}"
    if [ "$got" = "$want" ]; then
        ASSERT_PASS=$((ASSERT_PASS + 1))
        printf '  %sPASS%s %s\n' "$_GREEN" "$_RESET" "$label"
    else
        ASSERT_FAIL=$((ASSERT_FAIL + 1))
        printf '  %sFAIL%s %s\n    got:  %q\n    want: %q\n' "$_RED" "$_RESET" "$label" "$got" "$want"
    fi
}

assert_contains() {
    local haystack="$1" needle="$2" label="${3:-assert_contains}"
    if printf '%s' "$haystack" | grep -qF -- "$needle"; then
        ASSERT_PASS=$((ASSERT_PASS + 1))
        printf '  %sPASS%s %s\n' "$_GREEN" "$_RESET" "$label"
    else
        ASSERT_FAIL=$((ASSERT_FAIL + 1))
        printf '  %sFAIL%s %s\n    haystack did not contain: %q\n' "$_RED" "$_RESET" "$label" "$needle"
    fi
}

assert_not_contains() {
    local haystack="$1" needle="$2" label="${3:-assert_not_contains}"
    if printf '%s' "$haystack" | grep -qF -- "$needle"; then
        ASSERT_FAIL=$((ASSERT_FAIL + 1))
        printf '  %sFAIL%s %s\n    haystack unexpectedly contained: %q\n' "$_RED" "$_RESET" "$label" "$needle"
    else
        ASSERT_PASS=$((ASSERT_PASS + 1))
        printf '  %sPASS%s %s\n' "$_GREEN" "$_RESET" "$label"
    fi
}

assert_exit_code() {
    local want="$1" got="$2" label="${3:-assert_exit_code}"
    if [ "$got" = "$want" ]; then
        ASSERT_PASS=$((ASSERT_PASS + 1))
        printf '  %sPASS%s %s\n' "$_GREEN" "$_RESET" "$label"
    else
        ASSERT_FAIL=$((ASSERT_FAIL + 1))
        printf '  %sFAIL%s %s expected exit %s got %s\n' "$_RED" "$_RESET" "$label" "$want" "$got"
    fi
}

assert_summary() {
    printf '\n%s passed, %s failed\n' "$ASSERT_PASS" "$ASSERT_FAIL"
    [ "$ASSERT_FAIL" -eq 0 ]
}
