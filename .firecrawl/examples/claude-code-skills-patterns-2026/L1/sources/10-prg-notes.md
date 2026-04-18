# Claude Code Agent Skills

Jan 18, 20264 min read

- [notes](https://prg.sh/tags/notes)
- [AI](https://prg.sh/tags/AI)
- [LLM](https://prg.sh/tags/LLM)
- [CLI](https://prg.sh/tags/CLI)
- [development](https://prg.sh/tags/development)
- [agents](https://prg.sh/tags/agents)

Agent Skills are modular knowledge packages in [Claude Code](https://prg.sh/bookmarks/Claude-Code) that activate automatically when your task matches their description. Unlike [slash commands](https://prg.sh/notes/Claude-Code-Slash-Commands) (explicit invocation) or [subagents](https://prg.sh/notes/Claude-Code-Subagents) (isolated workers), skills add expertise to your current conversation without switching contexts.

## How Skills Work

**Progressive disclosure architecture:**

1. At startup, Claude pre-loads only name + description of every installed skill
2. When your request matches a skill’s description, Claude asks permission to load it
3. Full SKILL.md content loads into context only after approval
4. Supporting files (scripts, references) load on-demand as needed

This keeps token costs low until expertise is actually needed.

## SKILL.md Structure

The only required file. Two parts: YAML frontmatter + markdown instructions.

```
---
name: code-reviewer
description: Expert code review focusing on security, performance, and maintainability. Use when reviewing pull requests or examining code quality.
---

# Code Review Guidelines

## Process
1. Check for security vulnerabilities
2. Evaluate performance implications
3. Assess code readability and maintainability

## Reference
See @references/security-checklist.md for OWASP patterns.

## Scripts
Run @scripts/lint-check.sh for automated analysis.
```

### Required Fields

| Field | Constraints | Purpose |
| --- | --- | --- |
| `name` | Lowercase, hyphens, max 64 chars | Unique identifier |
| `description` | Max 1024 chars | Triggers skill activation |

### Optional Fields

| Field | Purpose |
| --- | --- |
| `allowed-tools` | Restrict available tools (security control) |
| `version` | Track skill versions |
| `disable-model-invocation` | Require manual `/skill-name` invocation |
| `mode` | Mark as behavior modifier (shows in “Mode Commands” section) |

### Tool Restrictions

```
---
name: safe-reader
description: Read-only file exploration. Use for audits and reviews.
allowed-tools:
  - Read
  - Grep
  - Glob
---
```

When active, Claude can only use specified tools without permission prompts.

## Directory Structure

Skills can bundle supporting resources:

```
my-skill/
├── SKILL.md           # Core instructions (required)
├── scripts/           # Executable Python/Bash (zero-context execution)
├── references/        # Supplemental docs (loaded on-demand)
└── assets/            # Templates, binary files
```

**scripts/**: Run via Bash without loading into context. Only output consumes tokens.

**references/**: Link from SKILL.md. Keep one level deep (no nested references).

**Best practice**: Keep SKILL.md under 5,000 words. Split complex content to sub-files.

## Where Skills Live

| Location | Scope | Use Case |
| --- | --- | --- |
| `~/.claude/skills/` | All projects | General-purpose (code review, docs) |
| `.claude/skills/` | Single project | Team conventions, project workflows |
| Plugin marketplaces | Installable | Shared across organizations |
| [MCP](https://prg.sh/notes/Model-Context-Protocol) servers | Remote | Dynamic, API-backed skills |

## Skills vs Commands vs Subagents

| Aspect | Skills | Slash Commands | Subagents |
| --- | --- | --- | --- |
| Invocation | Auto (description match) | Manual (`/command`) | Task delegation |
| Context | Same conversation | Same or forked | Isolated window |
| Use case | Expertise injection | Repeatable workflows | Parallel work, isolation |
| Files | Directory + SKILL.md | Single `.md` file | Single `.md` file |

**Mental model:**

- Skills = knowledge Claude applies
- Commands = actions you trigger
- Subagents = workers you delegate to

Slash commands can orchestrate subagents. Subagents can invoke skills. Skills teach Claude how to use tools that [MCP](https://prg.sh/notes/Model-Context-Protocol) provides.

## Improving Activation Reliability

Skills activate via LLM reasoning, not algorithmic matching. Two proven approaches for reliable activation (80%+ success vs 50% baseline):

**Strong trigger descriptions:**

- Include concrete use cases, file types, technical terms
- Write in third person: “Use when reviewing TypeScript files”
- Be specific: “analyzing React component performance” beats “code review”

**Prompt injection via hooks:**

- [Hooks](https://prg.sh/notes/Claude-Code-Hooks) can inject reminders on every prompt
- Forces Claude to evaluate skill relevance continuously
- Higher activation than relying on semantic matching alone

## Creating Skills

**Interactive:** Claude can generate skills from natural language descriptions

**Manual:**

```
mkdir -p .claude/skills/my-skill
echo '---
name: my-skill
description: What it does and when to use it
---

Instructions here...' > .claude/skills/my-skill/SKILL.md
```

**From templates:** Copy from [anthropics/skills](https://github.com/anthropics/skills) (44k+ stars)

## Example Skills

### Brand Guidelines

```
---
name: brand-writer
description: Apply company voice and style guidelines to content. Use for external communications, documentation, and marketing materials.
---

# Brand Voice

## Tone
Direct, warm, technically precise. Never corporate speak.

## Banned phrases
- "leverage", "synergy", "paradigm shift"
- "at the end of the day"
- "game-changer", "best practices"

## Reference
See @references/style-guide.md for complete guidelines.
```

### Test Runner

```
---
name: test-runner
description: Run and analyze test suites. Use after code changes or when investigating test failures.
allowed-tools:
  - Bash
  - Read
  - Grep
---

# Test Workflow

1. Detect framework (Jest, pytest, etc.)
2. Run relevant tests
3. If failures, analyze stack traces
4. Suggest fixes with root cause

## Scripts
@scripts/detect-framework.sh
@scripts/run-tests.sh
```

## Cost Considerations

Every installed skill adds name + description to every request. 20 skills might add 1,000+ tokens before you ask anything.

Mitigations:

- Delete unused skills
- Use project-level skills over user-level when possible
- Consider `disable-model-invocation: true` for rarely-used skills

## Related

- [Claude Code](https://prg.sh/bookmarks/Claude-Code)
- [Commands for explicit invocation](https://prg.sh/notes/Claude-Code-Slash-Commands)
- [Subagents for isolated work](https://prg.sh/notes/Claude-Code-Subagents)
- [Hooks for lifecycle automation](https://prg.sh/notes/Claude-Code-Hooks)
- [MCP for external tools](https://prg.sh/notes/Model-Context-Protocol)

## Sources

- [Agent Skills - Claude Code Docs](https://code.claude.com/docs/en/skills)
- [Agent Skills - Platform Docs](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)
- [Equipping Agents for the Real World](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- [Skills Explained - Claude Blog](https://claude.com/blog/skills-explained)
- [GitHub: anthropics/skills](https://github.com/anthropics/skills)
- [Awesome Claude Skills](https://github.com/travisvn/awesome-claude-skills)
- [Claude Skills Deep Dive](https://leehanchung.github.io/blogs/2025/10/26/claude-skills-deep-dive/)
- [Skills Activation Reliability](https://scottspence.com/posts/how-to-make-claude-code-skills-activate-reliably)
- [Claude Code Customization Guide](https://alexop.dev/posts/claude-code-customization-guide-claudemd-skills-subagents/)

* * *

### Related reading

[Feb 09, 2026\\
**Claude Code Agent Teams** \\
Multi-session orchestration where independent Claude instances coordinate through shared tasks and direct messaging\\
\\
notesAILLM](https://prg.sh/notes/Claude-Code-Agent-Teams) [Jan 04, 2026\\
**Claude Code Subagents** \\
Isolated AI workers in Claude Code with their own context windows, tools, and permissions\\
\\
notesAILLM](https://prg.sh/notes/Claude-Code-Subagents) [Jan 18, 2026\\
**Claude Code Hooks** \\
Shell commands that run at specific points in Claude Code's lifecycle for automation and validation\\
\\
notesAILLM](https://prg.sh/notes/Claude-Code-Hooks)

### Backlinks

- [Agentic Context Engineering](https://prg.sh/bookmarks/Agentic-Context-Engineering)
ICLR 2026 paper introducing ACE, a framework that treats LLM contexts as self-evolving playbooks instead of static prompts

- [Claude Code](https://prg.sh/bookmarks/Claude-Code)
Anthropic's terminal-first coding agent that reads your codebase, runs commands, and ships code autonomously

- [Pi Coding Agent](https://prg.sh/bookmarks/Pi-Coding-Agent)
Mario Zechner's minimal, four-tool AI coding agent that bets on leaving things out

- [Claude Code Agent Teams](https://prg.sh/notes/Claude-Code-Agent-Teams)
Multi-session orchestration where independent Claude instances coordinate through shared tasks and direct messaging

- [Claude Code Slash Commands](https://prg.sh/notes/Claude-Code-Slash-Commands)
Complete reference for built-in and custom slash commands in Claude Code

- [Claude Code Subagents](https://prg.sh/notes/Claude-Code-Subagents)
Isolated AI workers in Claude Code with their own context windows, tools, and permissions

- [Context Engineering](https://prg.sh/notes/Context-Engineering)
The discipline of filling an LLM's context window with the right information for each step, replacing prompt engineering as the core AI skill

- [Harness Engineering](https://prg.sh/notes/Harness-Engineering)
The discipline of designing everything around an AI model that makes it reliable in production