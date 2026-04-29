#!/usr/bin/env bash
# scripts/lib/osint-helpers.sh — shared utilities for /osint-research skill.
# Deployed to ~/.claude/scripts/lib/ by install.sh.

set -uo pipefail

osint_make_slug() {
    local target="$1"
    local sanitized
    sanitized=$(printf '%s' "$target" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g; s/--*/-/g; s/^-//; s/-$//')
    printf '%s-%s\n' "$sanitized" "$(date +%Y%m%d-%H%M)"
}

osint_artifact_dir() {
    local slug="$1"
    printf '.firecrawl/osint/%s\n' "$slug"
}

# Standalone CLI for testing / debugging.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    case "${1:-}" in
        slug) osint_make_slug "$2";;
        dir) osint_artifact_dir "$2";;
        *) echo "usage: $0 {slug|dir} <arg>" >&2; exit 1;;
    esac
fi
