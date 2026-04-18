# Source 10: PRG — Claude Code Agent Skills notes

**URL:** https://prg.sh/notes/Claude-Code-Agent-Skills
**Type:** developer-notes (concise reference)
**Date:** January 18, 2026
**Quality:** A (tight, accurate)
**Relevant to:** subq1 (anatomy), subq3 (limitations)

## Key facts

- **Skills vs Commands vs Subagents** comparison table:
  - Skills: auto-invoked (description match), same conversation, adds expertise
  - Commands: manual (`/command`), same or forked, triggers actions
  - Subagents: task delegation, isolated window, parallel work
  - Hierarchy: "Slash commands can orchestrate subagents. Subagents can invoke skills. Skills teach Claude how to use tools that MCP exposes."
- **Activation reliability:** 80%+ with strong trigger descriptions, vs 50% baseline without
- **Third-person description writing:** "Use when reviewing TypeScript files"
- **Prompt injection via hooks** can force continuous skill re-evaluation
- `anthropics/skills` repo reportedly 44k+ stars

## Key facts — limitations

- **Token cost:** every installed skill adds name + description to every request → 20 skills ≈ 1,000+ tokens before user asks anything
- **Mitigations:**
  - Delete unused skills
  - Project-level skills over user-level
  - `disable-model-invocation: true` for skills that should only be explicit
- Locations hierarchy:
  - User-level: `~/.claude/skills/`
  - Project: `.claude/skills/`
  - Marketplace: `.claude/plugins/marketplaces/`

## Key quotes

> "Every installed skill adds name + description to every request. 20 skills might add 1,000+ tokens before you ask anything."
> "Skills activate via LLM reasoning, not algorithmic matching."

## Notes

- **Critical quant:** 20 skills = 1,000+ tokens overhead — real context cost
- Skills/Commands/Subagents comparison is best-in-class
- Third-person description writing tip reinforces Bibek Poudel's "description is trigger" thesis
