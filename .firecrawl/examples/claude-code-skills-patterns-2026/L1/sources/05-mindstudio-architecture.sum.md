# Source 05: MindStudio — Why Your skill.md Should Only Contain Process Steps

**URL:** https://www.mindstudio.ai/blog/claude-code-skills-architecture-skill-md-reference-files/
**Type:** tech-blog (architecture opinion)
**Date:** 2026
**Quality:** B
**Relevant to:** subq1 (architecture), subq3 (complexity/limitations)

## Key facts

- **Core argument:** Skills get brittle as they grow because everything gets crammed into one SKILL.md (process + context + rules + examples + edge cases)
- **Four-part SKILL.md template:**
  1. Skill Description (2-4 sentences max — "for Claude's scope understanding, not for humans")
  2. Process steps (the actual workflow)
  3. Reference file pointers (not content)
  4. Examples
- **Rule:** Process goes in `skill.md`, context goes in reference files
- "Claude Code encounters a skill, reads the file, internalizes the instructions, and executes accordingly" — implying each added line compounds context cost

## Key quotes

> "The root cause is almost always the same. Everything is crammed into one skill.md file. It seems logical. One file, one skill. But this structure fights against how Claude Code actually processes instructions."
> "The correct architecture separates concerns: process goes in skill.md, context goes in reference files."

## Notes

- Addresses **real failure mode** — skills becoming inconsistent as they grow
- Supports Anthropic's progressive-disclosure architecture with practical template
- Gap: doesn't give explicit length thresholds (Anthropic says 5K words)
