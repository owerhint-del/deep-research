#!/usr/bin/env bash
# tests/security/test_phase2_scrape_safety.sh
# Simulates Phase 2: orchestrator picks a top-URL → must check inbound-filter
# BEFORE invoking Firecrawl. We stand in for Firecrawl with a marker file.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
FILTER="$SCRIPT_DIR/../../skills/osint-research/lib/inbound-filter.sh"

echo "== test_phase2_scrape_safety =="

simulated_orchestrator_phase2() {
    local url="$1"
    # Wrap as NDJSON, run through filter
    local survived
    survived=$(printf '{"url":"%s","content":""}\n' "$url" | bash "$FILTER" 2>/dev/null)
    if [ -z "$survived" ]; then
        echo "BLOCKED"
    else
        echo "WOULD_SCRAPE: $url"
    fi
}

assert_eq "$(simulated_orchestrator_phase2 https://pastebin.com/leak)" "BLOCKED" "blocklisted top-URL not scraped"
assert_eq "$(simulated_orchestrator_phase2 https://example.com/page)" "WOULD_SCRAPE: https://example.com/page" "clean URL passes"

assert_summary
