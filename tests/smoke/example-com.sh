#!/usr/bin/env bash
# tests/smoke/example-com.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
ROOT="$SCRIPT_DIR/../.."

echo "== smoke: example.com =="

# 1. Classify
got=$(bash "$ROOT/skills/osint-research/lib/entity-classifier.sh" example.com)
assert_eq "$got" "domain" "example.com classified as domain"

# 2. dorks for domain
got=$(bash "$ROOT/skills/osint-research/channels/dorks.sh" --type domain --target example.com 2>/dev/null)
assert_contains "$got" "site:linkedin.com" "dorks generated"

# 3. crtsh fixture flow
fixture='[{"name_value":"www.example.com\nmail.example.com"}]'
crtsh_out=$(bash "$ROOT/skills/osint-research/channels/crtsh.sh" --type domain --target example.com --fixture <(printf '%s' "$fixture"))
assert_contains "$crtsh_out" '"channel":"crtsh"' "crtsh fixture flows"

# 4. inbound filter passes clean results
filtered=$(printf '%s\n' "$crtsh_out" | bash "$ROOT/skills/osint-research/lib/inbound-filter.sh" 2>/dev/null)
assert_contains "$filtered" "www.example.com" "clean results survive filter"

# 5. findings extractor assigns priorities
findings=$(printf '%s\n' "$filtered" | bash "$ROOT/skills/osint-research/lib/findings-extractor.sh")
assert_contains "$findings" '"priority"' "priorities assigned"

assert_summary
