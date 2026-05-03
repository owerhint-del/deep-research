#!/usr/bin/env bash
# =====================================================================
# verify-research.sh — shared verification library for L1-L5 skills
# =====================================================================
#
# Centralizes the Bash verification logic previously duplicated across
# skill SKILL.md files. Skills source this and call its functions
# instead of inlining 30+ lines of checks.
#
# Benefits:
#   - single source of truth for citation regex (v0.2.2 multi-cite fix)
#   - fixing a check in one place updates all skills
#   - skills stay slim (load less into Claude's context)
#
# Usage from inside a skill's pipeline:
#
#   source ~/.claude/scripts/lib/verify-research.sh
#   verify_l1 "$SLUG" || exit 1
#   verify_l2 "$SLUG" || exit 1
#   verify_l3 "$SLUG" || exit 1
#
# Each function prints ✅ on success, ❌ on failure, returns 0/1.
#
# =====================================================================

set -u

# Base directory for research artifacts. Override via env if running
# against .firecrawl/examples/ or a custom location.
DEEP_RESEARCH_BASE_DIR="${DEEP_RESEARCH_BASE_DIR:-.firecrawl/research}"

# --- Internal helpers --------------------------------------------------

# Extract unique citation numbers from a report, handling both [N] and
# [N, M, K] multi-citation formats. The v0.2.2 fix that prompted this
# shared library.
_extract_citations() {
    local report="$1"
    grep -oE '\[[0-9][0-9, ]*\]' "$report" 2>/dev/null \
        | tr -d '[] ' \
        | tr ',' '\n' \
        | grep -vE '^$' \
        | sort -un
}

# Verify every [N] citation in a report has a "^N." entry in bibliography
_verify_citations() {
    local report="$1"
    local bib="$2"
    local citations
    citations=$(_extract_citations "$report")
    for N in $citations; do
        grep -qE "^${N}\." "$bib" || {
            echo "❌ Citation [${N}] in $(basename "$report") not found in $(basename "$bib")"
            return 1
        }
    done
    return 0
}

# Check a single source file is non-trivially sized
_check_source_size() {
    local file="$1"
    local min_bytes="${2:-500}"
    local size
    size=$(wc -c < "$file" 2>/dev/null || echo 0)
    [ "$size" -ge "$min_bytes" ] || {
        echo "❌ $file is $size bytes (need ≥${min_bytes}) — likely error page or truncated"
        return 1
    }
    return 0
}

# Log which optional cross-channel artifacts (Codex / Tavily Research / Exa) are
# present in a tier directory. Informational only — never blocks. Helps users see
# at a glance which independent verification channels actually ran.
#
# v0.9.0: Tavily Research replaces the v0.6.0 Perplexity Answer Channel.
_log_optional_channels() {
    local dir="$1"
    local tier_label="${2:-tier}"
    local found=()

    # Codex cross-model channel (codex-*.md outputs; .status sidecars don't match this glob)
    if compgen -G "$dir/codex-*.md" > /dev/null 2>&1; then
        local codex_count
        codex_count=$(ls "$dir"/codex-*.md 2>/dev/null | wc -l | tr -d ' ')
        found+=("codex×${codex_count}")
    fi

    # Tavily Research answer channel / fact-check (v0.9.0+)
    if compgen -G "$dir/tavily-research-*" > /dev/null 2>&1 \
        || compgen -G "$dir/tavily-factcheck-*.json" > /dev/null 2>&1 \
        || compgen -G "$dir/tavily-verify-*.json" > /dev/null 2>&1; then
        local tvr_count
        tvr_count=$(ls "$dir"/tavily-research-* "$dir"/tavily-factcheck-*.json "$dir"/tavily-verify-*.json 2>/dev/null | wc -l | tr -d ' ')
        found+=("tavily-research×${tvr_count}")
    fi

    # Exa neural channel
    if compgen -G "$dir/exa-*.json" > /dev/null 2>&1; then
        local exa_count
        exa_count=$(ls "$dir"/exa-*.json 2>/dev/null | wc -l | tr -d ' ')
        found+=("exa×${exa_count}")
    fi

    if [ ${#found[@]} -gt 0 ]; then
        echo "ℹ️  $tier_label optional channels: ${found[*]}"
    else
        echo "ℹ️  $tier_label optional channels: none active (single-channel run)"
    fi
}

# --- L1 verification ---------------------------------------------------

verify_l1() {
    local slug="$1"
    local dir="$DEEP_RESEARCH_BASE_DIR/$slug/L1"

    [ -s "$dir/plan.md" ]         || { echo "❌ L1 plan.md missing"; return 1; }
    [ -s "$dir/report.md" ]       || { echo "❌ L1 report.md missing"; return 1; }
    [ -s "$dir/bibliography.md" ] || { echo "❌ L1 bibliography.md missing"; return 1; }

    local words
    words=$(wc -w < "$dir/report.md")
    [ "$words" -ge 700 ] || { echo "❌ L1 report only $words words (need ≥700)"; return 1; }

    local src_count sum_count
    src_count=$(ls "$dir"/sources/*.md 2>/dev/null | grep -vc '\.sum\.md$' | tr -d ' ')
    sum_count=$(ls "$dir"/sources/*.sum.md 2>/dev/null | wc -l | tr -d ' ')
    [ "$src_count" -ge 10 ]             || { echo "❌ L1 only has $src_count scrapes (need ≥10)"; return 1; }
    [ "$sum_count" -eq "$src_count" ]   || { echo "❌ L1 summary count $sum_count != scrape count $src_count"; return 1; }

    for f in "$dir"/sources/*.md; do
        echo "$f" | grep -q '\.sum\.md$' && continue
        _check_source_size "$f" 500 || return 1
    done

    _verify_citations "$dir/report.md" "$dir/bibliography.md" || return 1

    echo "✅ L1 VERIFIED: $src_count scrapes, $sum_count summaries, ${words}-word report, citations traceable"
    return 0
}

# --- L2 verification ---------------------------------------------------

# L2 has 4 checkpoints embedded in the pipeline. These functions support
# the skill's staged verification.

verify_l2_checkpoint_1() {
    # "Verify L1 foundation" — L2 cannot start without good L1
    local slug="$1"
    verify_l1 "$slug" | sed 's/L1 VERIFIED/CHECKPOINT 1 PASSED (L1 foundation)/'
}

verify_l2_checkpoint_2() {
    # "Searches produced URLs"
    local slug="$1"
    local dir="$DEEP_RESEARCH_BASE_DIR/$slug/L2"

    local search_count url_count
    search_count=$(ls "$dir"/search-*.json 2>/dev/null | wc -l | tr -d ' ')
    [ "$search_count" -ge 2 ] || { echo "❌ Only $search_count search files (need ≥2)"; return 1; }

    for f in "$dir"/search-*.json; do
        _check_source_size "$f" 500 || return 1
    done

    url_count=$(cat "$dir"/search-*.json 2>/dev/null \
        | jq -r '[.. | .url? // empty] | unique | .[]' 2>/dev/null \
        | wc -l | tr -d ' ')
    [ "$url_count" -ge 10 ] || { echo "❌ Only $url_count unique URLs (need ≥10)"; return 1; }

    echo "✅ CHECKPOINT 2 PASSED: $search_count searches, $url_count unique URLs"
    return 0
}

verify_l2_checkpoint_3() {
    # "Scrapes completed" — THE critical anti-hollow-synthesis check
    local slug="$1"
    local src="$DEEP_RESEARCH_BASE_DIR/$slug/L2/sources"

    local scrape_count sum_count
    scrape_count=$(ls "$src"/*.md 2>/dev/null | grep -vc '\.sum\.md$' | tr -d ' ')
    [ "$scrape_count" -ge 8 ] || {
        echo "❌ CRITICAL: Only $scrape_count L2 sources scraped (need ≥8)"
        echo "   This is the hollow-synthesis failure mode. Re-run scrape step."
        return 1
    }

    for f in "$src"/*.md; do
        echo "$f" | grep -q '\.sum\.md$' && continue
        _check_source_size "$f" 500 || return 1
    done

    sum_count=$(ls "$src"/*.sum.md 2>/dev/null | wc -l | tr -d ' ')
    [ "$sum_count" -eq "$scrape_count" ] || {
        echo "❌ Summary count ($sum_count) ≠ scrape count ($scrape_count)"
        return 1
    }

    for f in "$src"/*.sum.md; do
        _check_source_size "$f" 1000 || return 1
    done

    echo "✅ CHECKPOINT 3 PASSED: $scrape_count scrapes, all non-trivial, all summarized"
    return 0
}

verify_l2_checkpoint_4() {
    # "Final verify before delivering report"
    local slug="$1"
    local dir="$DEEP_RESEARCH_BASE_DIR/$slug/L2"

    [ -s "$dir/report.md" ]          || { echo "❌ L2 report missing"; return 1; }
    local words
    words=$(wc -w < "$dir/report.md")
    [ "$words" -ge 1500 ] || { echo "❌ L2 report only $words words (need ≥1500)"; return 1; }

    [ -s "$dir/bibliography.md" ]    || { echo "❌ L2 bibliography missing"; return 1; }
    [ -f "$dir/contradictions.md" ]  || { echo "❌ contradictions.md not created"; return 1; }
    [ -f "$dir/confidence.md" ]      || { echo "❌ confidence.md not created"; return 1; }
    [ -s "$dir/gap-analysis.md" ]    || { echo "❌ gap-analysis.md missing"; return 1; }
    [ -s "$dir/followup-plan.md" ]   || { echo "❌ followup-plan.md missing"; return 1; }

    _verify_citations "$dir/report.md" "$dir/bibliography.md" || return 1

    echo "✅ CHECKPOINT 4 PASSED: ${words}-word report, bibliography verified, all citations traceable"
    _log_optional_channels "$dir" "L2"
    return 0
}

# Convenience: run all 4 L2 checkpoints in sequence
verify_l2() {
    local slug="$1"
    verify_l2_checkpoint_1 "$slug" || return 1
    verify_l2_checkpoint_2 "$slug" || return 1
    verify_l2_checkpoint_3 "$slug" || return 1
    verify_l2_checkpoint_4 "$slug" || return 1
    echo "✅ All 4 L2 CHECKPOINTs PASSED"
    return 0
}

# --- L3 verification ---------------------------------------------------

verify_l3() {
    local slug="$1"
    local dir="$DEEP_RESEARCH_BASE_DIR/$slug/L3"

    [ -s "$dir/report.md" ]             || { echo "❌ L3 report missing"; return 1; }
    local words
    words=$(wc -w < "$dir/report.md")
    # Target is 2000-3000 words (skill-level guidance).
    # Verification minimum is 1700 — below this the report is likely
    # truncated or synthesized from incomplete input, above is acceptable.
    # Keep target/min separate: target pushes quality, min prevents broken output.
    [ "$words" -ge 1700 ] || { echo "❌ L3 report only $words words (hard min 1700, target 2000-3000)"; return 1; }

    [ -s "$dir/executive-summary.md" ] || { echo "❌ executive-summary.md missing"; return 1; }
    [ -s "$dir/critic-report.md" ]     || { echo "❌ critic-report.md missing — subagent was not invoked"; return 1; }
    [ -s "$dir/fact-check.md" ]        || { echo "❌ fact-check.md missing"; return 1; }
    [ -s "$dir/bibliography.md" ]      || { echo "❌ bibliography.md missing"; return 1; }
    [ -s "$dir/perspective-plan.md" ]  || { echo "❌ perspective-plan.md missing"; return 1; }

    local l3_sum_count
    l3_sum_count=$(ls "$dir"/sources/*.sum.md 2>/dev/null | wc -l | tr -d ' ')
    [ "$l3_sum_count" -ge 8 ] || { echo "❌ Only $l3_sum_count L3 summaries (need ≥8)"; return 1; }

    _verify_citations "$dir/report.md" "$dir/bibliography.md" || return 1

    echo "✅ L3 FINAL CHECKPOINT PASSED: ${words}-word report, $l3_sum_count L3 sources, critic + fact-check verified, citations traceable"
    _log_optional_channels "$dir" "L3"
    return 0
}

# --- Top-level runner --------------------------------------------------
# When this script is executed directly (not sourced), allow CLI usage:
#   verify-research.sh l1 <slug>
#   verify-research.sh l2 <slug>
#   verify-research.sh l3 <slug>
if [ "${BASH_SOURCE[0]}" = "${0:-}" ] || [ -z "${BASH_SOURCE[0]:-}" ]; then
    TIER="${1:-}"
    SLUG="${2:-}"

    case "$TIER" in
        l1) verify_l1 "$SLUG" ;;
        l2) verify_l2 "$SLUG" ;;
        l2-cp1) verify_l2_checkpoint_1 "$SLUG" ;;
        l2-cp2) verify_l2_checkpoint_2 "$SLUG" ;;
        l2-cp3) verify_l2_checkpoint_3 "$SLUG" ;;
        l2-cp4) verify_l2_checkpoint_4 "$SLUG" ;;
        l3) verify_l3 "$SLUG" ;;
        *)
            cat <<USAGE
Usage: verify-research.sh <tier> <slug>

Tiers:
  l1       — L1 final verification
  l2       — all 4 L2 checkpoints
  l2-cp1   — CP1 (L1 foundation)
  l2-cp2   — CP2 (searches)
  l2-cp3   — CP3 (scrapes, critical)
  l2-cp4   — CP4 (report + citations)
  l3       — L3 final checkpoint

Or source this file in another script:
  source "\$HOME/.claude/scripts/lib/verify-research.sh"
  verify_l1 "my-slug"
USAGE
            exit 2
            ;;
    esac
fi
