#!/usr/bin/env bash
# =====================================================================
# Deep Research — install script
# Copies all skills from skills/ into ~/.claude/skills/ and verifies.
# Idempotent — safe to re-run.
# =====================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_SRC="$REPO_ROOT/skills"
SKILLS_DST="$HOME/.claude/skills"

# --- colors ---
if [ -t 1 ]; then
    C_GREEN="\033[0;32m"; C_YELLOW="\033[0;33m"; C_RED="\033[0;31m"; C_BOLD="\033[1m"; C_RESET="\033[0m"
else
    C_GREEN=""; C_YELLOW=""; C_RED=""; C_BOLD=""; C_RESET=""
fi

echo ""
echo -e "${C_BOLD}Deep Research — installer${C_RESET}"
echo "================================"
echo ""

# --- preflight ---
if [ ! -d "$SKILLS_SRC" ]; then
    echo -e "${C_RED}ERROR${C_RESET}: skills directory not found at $SKILLS_SRC"
    echo "Are you running this from inside the cloned repo?"
    exit 1
fi

mkdir -p "$SKILLS_DST"

# --- check for existing installs ---
existing_count=0
for skill in quick-research research deep-research expert-research academic-research ultra-research; do
    if [ -d "$SKILLS_DST/$skill" ]; then
        existing_count=$((existing_count + 1))
    fi
done

if [ $existing_count -gt 0 ]; then
    echo -e "${C_YELLOW}Found $existing_count existing skill(s) in $SKILLS_DST${C_RESET}"
    echo "Existing files will be overwritten. Your custom skills in other directories are safe."
    echo ""
    printf "Continue? [y/N] "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
    echo ""
fi

# --- copy skills ---
installed=0
for skill_dir in "$SKILLS_SRC"/*/; do
    skill_name="$(basename "$skill_dir")"
    echo -n "Installing ${skill_name}... "
    rm -rf "$SKILLS_DST/$skill_name"
    cp -R "$skill_dir" "$SKILLS_DST/$skill_name"
    installed=$((installed + 1))
    echo -e "${C_GREEN}OK${C_RESET}"
done

if [ $installed -eq 0 ]; then
    echo -e "${C_RED}ERROR${C_RESET}: no skill directories found in $SKILLS_SRC"
    exit 1
fi

echo ""
echo -e "${C_GREEN}Installed $installed skill(s).${C_RESET}"
echo ""

# --- post-install check ---
echo "Verifying..."
all_ok=true
for skill in quick-research research deep-research expert-research academic-research ultra-research; do
    if [ -f "$SKILLS_DST/$skill/SKILL.md" ]; then
        echo -e "  ${C_GREEN}✓${C_RESET} $skill"
    else
        echo -e "  ${C_RED}✗${C_RESET} $skill (missing SKILL.md)"
        all_ok=false
    fi
done

echo ""

# --- next steps ---
echo -e "${C_BOLD}Next steps:${C_RESET}"
echo ""
echo "  1. Restart Claude Code to pick up new skills."
echo ""
echo "  2. Configure API keys:"
echo "     a) Firecrawl:"
echo "        firecrawl config"
echo ""
echo "     b) Tavily: add MCP server to ~/.claude.json — see docs/INSTALLATION.md"
echo ""
echo "     c) (Optional) Codex CLI for L2+:"
echo "        codex auth login"
echo ""
echo "  3. Test it:"
echo "     /quick-research what is the latest version of Bun"
echo ""
echo "Full guide: docs/INSTALLATION.md"
echo ""

if ! $all_ok; then
    exit 1
fi
