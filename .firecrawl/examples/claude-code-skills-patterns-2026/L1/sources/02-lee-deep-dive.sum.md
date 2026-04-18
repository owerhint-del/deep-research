# Source 02: Lee Hanchung — Claude Agent Skills First-Principles Deep Dive

**URL:** https://leehanchung.github.io/blogs/2025/10/26/claude-skills-deep-dive/
**Type:** tech-blog (deep analysis)
**Date:** October 26, 2025 (launch era)
**Quality:** A
**Relevant to:** subq1 (anatomy, composition, invocation internals)

## Key facts

- **SKILL.md** = two-part structure: YAML frontmatter (HOW to run) + markdown content (WHAT to do)
- Standard bundle directories: `scripts/` (executable Python/Bash), `references/` (documentation loaded into context), `assets/` (templates/binary files)
- **"Why two messages?"** — Claude receives skill as structured prompt (system-visible metadata + user-visible content) rather than single block; `isMeta` flags control visibility
- `allowed-tools` frontmatter restricts tool access when skill active
- Permission messages only appear when frontmatter specifies `allowed-tools` or model override — modular composition
- Best practice: **SKILL.md under 5,000 words** — prevents context bloat, push details into bundled resources via progressive disclosure

## Key quotes

> "Frontmatter is the header of the markdown file written in YAML. The frontmatter configures HOW the skill runs (permissions, model, metadata), while the markdown content tells Claude WHAT to do."
> "Skills become powerful when you bundle supporting resources alongside SKILL.md."

## Notes

- Written shortly after skills public launch (Oct 2025) — foundational perspective
- Deeper technical explanation than official docs — good for composition patterns
- Confirms 5K word limit as best-practice ceiling (not hard limit)
