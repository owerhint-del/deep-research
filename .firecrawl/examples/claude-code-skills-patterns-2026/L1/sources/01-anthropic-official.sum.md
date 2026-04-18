# Source 01: Anthropic — Agent Skills official docs

**URL:** https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
**Type:** official-docs
**Date:** 2026 (current)
**Quality:** A
**Relevant to:** subq1 (anatomy, structure, invocation)

## Key facts

- **Every Skill requires `SKILL.md`** with YAML frontmatter: `name` + `description` required, max 64 chars + 1024 chars respectively
- `name` must be lowercase letters/numbers/hyphens, cannot be "anthropic" or "claude"
- **Progressive disclosure architecture (3 levels):**
  - Level 1 (Metadata): always loaded, ~100 tokens/skill (name + description)
  - Level 2 (Instructions): loaded when skill triggered, under 5k tokens
  - Level 3 (Resources): loaded as needed, effectively unlimited (scripts executed via bash without loading into context)
- Optional fields: `allowed-tools` (security), `version`, `disable-model-invocation` (require explicit `/skill-name`), `mode`
- Skills are **model-invoked** (auto-discovered) vs slash commands (user-invoked)
- Official format published at agentskills.io (Dec 2025) — open standard, works across Claude Code, Codex, Antigravity

## Key quotes

> "Progressive disclosure ensures only relevant content occupies the context window at any given time."
> "Every Skill requires a SKILL.md file with YAML frontmatter."

## Notes

- Canonical source for structure rules
- Clarifies `name` reserved words ("anthropic", "claude") — important for authors
- 3-level loading system = fundamental architecture insight
