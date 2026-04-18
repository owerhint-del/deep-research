# Source 04: Turbodocx — How to Build a Claude Code Skill from Scratch (2026)

**URL:** https://www.turbodocx.com/blog/how-to-build-claude-code-skill
**Type:** tech-tutorial
**Date:** 2026
**Quality:** B
**Relevant to:** subq1 (skill authoring), subq2 (cross-agent portability)

## Key facts

- **Skills directories across agents** (SKILL.md portable):
  - Claude Code: `~/.claude/skills/`
  - GitHub Copilot: `~/.copilot/skills/` or `.github/skills/`
  - Cursor: `~/.cursor/skills/`
  - Gemini CLI: `~/.gemini/skills/`
- "Write the skill once, drop it into whichever folder matches the agent you use"
- Skill composition pattern (three parts):
  1. What the skill produces
  2. When to use it
  3. **Explicit trigger phrases** — "the real words a developer types, not idealized versions"
- **"Be slightly pushy"** principle: Claude's default is to handle requests itself rather than load skills — listing explicit trigger phrases in description counteracts under-triggering
- Bundle structure: `references/` for style guides/docs, `scripts/` for deterministic processing

## Key quotes

> "Claude's default behavior is to handle requests itself rather than load a skill. It naturally undertriggers. Listing explicit trigger phrases in the description counteracts this."
> "Write the skill once. Drop it into whichever folder matches the agent you use. Done."

## Notes

- Confirms SKILL.md format as cross-agent standard (Claude Code / Copilot / Cursor / Gemini)
- "Slightly pushy description" is non-obvious insight for skill authors
- Commit-message-writer used as minimal example throughout
