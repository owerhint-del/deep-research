# Source 06: Bibek Poudel — The SKILL.md Pattern: How to Write AI Agent Skills That Actually Work

**URL:** https://bibek-poudel.medium.com/the-skill-md-pattern-how-to-write-ai-agent-skills-that-actually-work-72a3169dd7ee
**Type:** tech-blog (practical patterns)
**Date:** February 26, 2026
**Quality:** A
**Relevant to:** subq1 (writing effective skills), subq3 (common failures)

## Key facts

- **"If a skill does not trigger, it is almost never the instructions. It is the description."** — central thesis
- SKILL.md is an **open standard** published by Anthropic at agentskills.io in Dec 2025, works across Claude Code, OpenAI Codex, OpenClaw
- **Three-level loading system** explained concretely with example of Level 3 (scripts run without loading source into context)
- `allowed-tools` is useful for read-only skills: prevents agent from accidentally writing/executing
- SKILL.md body stays **under 400 lines** (author's personal rule) — different from Anthropic's 5K words
- **Four skill categories** (by complexity):
  1. Inline-only (e.g. `git-commit-writer`)
  2. File-output patterns (e.g. `readme-writer`)
  3. Split skills (e.g. `code-reviewer` with reference files)
  4. **MCP-enhancement skills** (e.g. `linear-sprint-planner` with MCP server context)
- "Skills do not guarantee execution. The model still decides whether to follow" — important caveat

## Key quotes

> "The description field in your YAML frontmatter is not for humans. It is the trigger condition the agent uses when deciding whether to load this skill."
> "Skills do not guarantee execution. The model still decides whether to follow the instructions. Think of them as structured guidance that dramatically increases consistency, not deterministic automation."

## Notes

- **Strongest practical voice** on what makes skills work
- Explicit four-category taxonomy is reusable framework
- Skill authoring trap (description != instructions) is high-value insight
