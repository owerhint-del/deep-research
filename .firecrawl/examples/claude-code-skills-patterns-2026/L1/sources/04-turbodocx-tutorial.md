Claude Code & AI Tooling

# How to Build Your OwnClaude Code Skill

A plain-English guide to creating a skill from scratch. No prior experience needed. You will build a working skill, install it, and understand exactly how it works by the end.

![Yacine Kahlerras](https://www.turbodocx.com/images/authors/yacine.jpg)

Yacine Kahlerras•Software Engineer, Platform & UX at TurboDocx

•April 2, 2026•12 min read

![How to Build Your Own Claude Code Skill](https://www.turbodocx.com/images/blog/claude-skill.png)

You already repeat yourself every day. You write commit messages the same way. You check the same things before opening a pull request. You follow the same steps every time you review code. Then you open Claude Code, explain it all from scratch, and hope it interprets things the same way as last time. If you have not seen how a full [feature-shipping session](https://www.turbodocx.com/blog/how-i-use-claude-code-to-ship-features-in-one-session) works, skills are the piece that makes it repeatable.

Skills fix that. A skill is a file you write once. Claude reads it every time you need it and follows the instructions inside, consistently, without you explaining anything. And because skills follow an [open standard defined by Anthropic](https://support.claude.com/en/articles/12512198-how-to-create-custom-skills), the same file works in Claude Code, GitHub Copilot, Cursor, and Gemini CLI. You can also browse [community-published skills on GitHub](https://github.com/anthropics/skills) to see what others have built.

This guide builds one from scratch — if you have not set up your project-level instructions yet, start with our [CLAUDE.md guide](https://www.turbodocx.com/resources/claude-md-guide) first. By the end you will have a working commit-message skill installed on your machine. More importantly, you will understand the structure well enough to build any skill you need.

TL;DR: what you are building

- A folder with one file inside: `SKILL.md`
- That file has two parts: a short header (frontmatter) and the instructions (body)
- The header tells Claude when to use it. The body tells it what to do.
- You drop the folder into `~/.claude/skills/` and you are done.

## What Exactly Is a Claude Code Skill?

A skill is a folder on your computer. Inside that folder is one required file: `SKILL.md`. That is it. No install scripts, no dependencies, no runtime. It is a text file Claude reads.

```
my-skill/
└── SKILL.md
```

The file has two parts separated by `---`. The top part (called frontmatter) is metadata written in YAML. The bottom part is plain markdown where you write the actual instructions.

```
---
name: my-skill
description: What this skill does and when to load it.
---

# My Skill

Instructions for the agent go here. Plain English is fine.
```

When you ask Claude to do something, it scans all your installed skills by reading just the name and description. If your request matches a description, Claude loads that skill's body and follows the instructions. The frontmatter is never shown to Claude as instructions. It is just the trigger mechanism.

Think of it like a recipe:

- Name:what the recipe is called
- Description:when you would cook this dish
- Body:the step-by-step instructions

| Part | Where | Purpose | Required |
| --- | --- | --- | --- |
| name | YAML frontmatter | How you invoke the skill with /skill-name | Yes |
| description | YAML frontmatter | What Claude reads to decide whether to load the skill | Yes |
| \# Body | Markdown below frontmatter | The actual instructions the agent follows | Yes |
| references/ | Subfolder | Extra context files Claude loads on demand | Optional |
| scripts/ | Subfolder | Python or JS scripts for deterministic tasks | Optional |

## What Should You Turn Into a Skill?

Not everything belongs in a skill. Before building one, ask yourself three questions:

1. 1


Do I do this the same way every time?



If yes, that repetition is a skill candidate. If you do it differently each time, a skill won't help much.

2. 2


Can I finish the sentence "I need this when I want to..."?



If you can finish that sentence clearly, you have a trigger condition. If you need three sentences, the scope is too fuzzy.

3. 3


Does the output always look the same?



Commit messages, PR descriptions, review checklists: fixed shapes. "Make this better": not a fixed shape.


| Skill Idea | Why It Works / Doesn't Work | Fit |
| --- | --- | --- |
| Commit message writer | Fixed trigger, structured output, repeatable every time you commit | Easy |
| PR description generator | Clear input (your branch diff), clear output (description template) | Easy |
| Code review checklist | Same checklist every review: security, tests, naming | Easy |
| Changelog entry writer | Consistent format across releases, easy to trigger | Easy |
| "Make this better" | Too vague. No fixed output. Better handled as a prompt. | Bad fit |
| "Help me think through this" | No trigger condition. No consistent output. Not a skill. | Bad fit |

## The Most Important Part: Writing the Description

Most first-time skills fail not because the instructions are wrong, but because the description is too vague and the skill never loads.

Claude only reads the name and description to decide whether to load a skill. The rest of the file is invisible until that decision is made. Which means: if your description does not match how someone would actually ask for help, the skill stays dormant forever.

Weak description (will undertrigger):

```
description: Generates commit messages.
```

Strong description (will trigger reliably):

```
description: Generates structured commit messages following the Conventional
  Commits standard. Use when you want to commit your changes and need a
  well-formatted message. Triggers on "write a commit message", "commit
  my changes", "summarize my staged diff", "what should my commit say",
  or any request to describe or document staged changes for version control.
```

The pattern is three things combined:

- 1.**What the skill produces:** "structured commit messages following theConventional Commits standard"
- 2.**When to use it:** "when you want to commit your changes"
- 3.**Exact trigger phrases:** the real words a developer types, not idealized versions

Why you need to be "slightly pushy"

Claude's default behavior is to handle requests itself rather than load a skill. It naturally undertriggers. Listing explicit trigger phrases in the description counteracts this. You are not being redundant, you are training the trigger condition.

## How to Write Instructions That Actually Work

Once the skill loads, Claude reads the body and follows the instructions. Two rules make the difference between instructions that produce consistent results and ones that drift:

Rule 1: Generate first, clarify second

Tell the agent to produce output immediately. If it needs to guess something, it should guess and note it after the output, not ask before. Asking questions every time kills the whole point of having a skill.

Rule 2: Define the output format explicitly

Don't say "write a good commit message." Say exactly what type, scope, description, body, and footer look like. Vague instructions produce vague results. Specific instructions produce consistent results.

Weak instructions (produces different output every time):

```
# Commit Message Writer

Look at the staged changes and write a commit message that describes what changed.
```

Strong instructions (produces consistent output every time):

```
# Commit Message Writer

Read the staged diff using `git diff --staged`. Generate a commit message
following the Conventional Commits standard.

Output format:
type(scope): short description under 72 characters

Body (if changes are non-trivial):
- What changed and why, not how
- One bullet per logical change

Footer (if applicable):
BREAKING CHANGE: description
Closes #issue-number
```

## Build It: The Complete commit-message-writer Skill

Time to build the actual skill. This is the full version, not a stripped-down example. Copy this exactly.

Step 1: Create the folder

```
# Mac / Linux
mkdir -p ~/.claude/skills/commit-message-writer

# Windows PowerShell
New-Item -ItemType Directory -Force -Path "$HOME\.claude\skills\commit-message-writer"
```

Step 2: Create SKILL.md inside that folder

Create a file at`~/.claude/skills/commit-message-writer/SKILL.md`and paste this content:

````
---
name: commit-message-writer
description: Generates structured commit messages following the Conventional Commits
  standard. Use when you want to commit your changes and need a well-formatted message.
  Triggers on "write a commit message", "commit my changes", "summarize my staged
  diff", "what should my commit say", or any request to describe or document staged
  changes for version control.
---

# commit-message-writer

You generate structured commit messages from staged git changes.

## How to invoke

Run `git diff --staged` to read the staged changes. If nothing is staged, tell the
user and suggest they run `git add` first.

Generate first. Do not ask clarifying questions before producing the commit message.
If you need to make assumptions about scope or type, make them and note them after
the output.

## Output format

```
type(scope): short description

[body — optional, include if changes are non-trivial]

[footer — optional]
```

**Type** — choose one:
- `feat` — a new feature
- `fix` — a bug fix
- `docs` — documentation changes only
- `refactor` — code change that neither fixes a bug nor adds a feature
- `test` — adding or updating tests
- `chore` — build process, tooling, or dependency updates

**Scope** — the module, file, or area affected. Use the directory name or component
name. Omit if the change spans the entire codebase.

**Short description** — imperative mood, under 72 characters, no period at the end.
"Add user authentication" not "Added user authentication" or "Adds user authentication."

**Body** — what changed and why, not how. One bullet per logical change. Skip if the
short description is self-explanatory.

**Footer** — include `BREAKING CHANGE:` if the commit breaks backward compatibility.
Include `Closes #N` if it resolves a GitHub issue.

## Quality rules

- Never use "updated", "changed", or "modified" in the short description — be specific
- Never write "various improvements" or "misc fixes" — name what improved
- If more than three files changed across unrelated concerns, flag it:
  "These changes may be better split into separate commits: [list concerns]"
- The short description must be under 72 characters — count before outputting

## Example output

Input: staged changes adding a rate limiter to an API endpoint

```
feat(api): add rate limiting to /query endpoint

- Limits requests to 100 per minute per IP
- Returns 429 with Retry-After header when limit is exceeded
- Adds rate limit config to environment variables

Closes #47
```
````

That's the whole skill

No dependencies, no install script, no configuration. One folder, one file. Claude reads it and follows the instructions.

## Install It and Test That It Works

The skill is already installed. You created the file in the right place.Claude Code reads `~/.claude/skills/`automatically. Now verify and test it.

Verify the file exists:

```
cat ~/.claude/skills/commit-message-writer/SKILL.md
```

Test with the explicit trigger (most reliable):

```
# In Claude Code, with some staged changes:
/commit-message-writer
```

Test with natural language (the real test):

```
write a commit message for my staged changes
what should my commit say
summarize my diff for git
```

All three should load the skill and produce a structured commit message. If the natural language triggers don't work, you need more trigger phrases in the description (see the next section).

Test the edge cases:

```
# Test with nothing staged — skill should tell you to run git add
git status  # make sure nothing is staged
# In Claude Code: "write a commit message"
# Expected: skill says nothing is staged and suggests git add

# Test with changes across unrelated files — skill should flag it
git add src/api.ts src/styles.css README.md
# In Claude Code: "write a commit message"
# Expected: skill suggests splitting into separate commits
```

## How to Make the Skill Better Over Time

The first version is always a draft. Every skill improves through use. Here are the three most common problems and how to fix each one.

Problem 1: The skill doesn't trigger when it should

You typed "summarize my changes for git" and nothing loaded. Fix: add that exact phrase to the description's trigger list.

```
# Before
description: ... Triggers on "write a commit message", "commit my changes" ...

# After — add the phrase that didn't trigger
description: ... Triggers on "write a commit message", "commit my changes",
  "summarize my changes for git", ...
```

Problem 2: The output format drifts

Claude started using past tense or skipping the scope. Fix: add explicit counterexamples to the instructions.

```
## Common mistakes to avoid

Wrong: "Updated the authentication flow"
Right: "refactor(auth): simplify token validation logic"

Wrong: "Fixed bugs"
Right: "fix(api): handle null response from upstream service"
```

Problem 3: You want the skill to do more

Resist the urge to add changelog generation, PR descriptions, and commit review into the same skill. Build a second skill instead. Each skill does one thing well.

Theagent skill standardis designed for composition. You can have many skills installed at once without blowing up the context window. Claude only loads the ones that match. Keep each skill focused.

## Bonus: This Skill Works in Every Agent

The Agent Skills standard is open. A skill you build for Claude Code installs without changes in GitHub Copilot, Cursor, and Gemini CLI. Only the install path differs:

| Agent | Skills directory | Platform |
| --- | --- | --- |
| Claude Code | ~/.claude/skills/ | All |
| GitHub Copilot | ~/.copilot/skills/ or .github/skills/ | VS Code |
| Cursor | ~/.cursor/skills/ | Mac/Win |
| Gemini CLI | ~/.gemini/skills/ | All |

Write the skill once. Drop it into whichever folder matches the agent you use. Done.

## What to Build Next

The commit-message-writer is intentionally the simplest possible skill: instructions only, no scripts, no extra files. Once it clicks, the same structure handles anything repeatable.

- **PR description generator**: same shape. Read the diff, apply a structure. Different trigger phrases and output sections.
- **Code review checklist**: encode whatever your team actually checks. Security concerns, test coverage, naming standards.
- **Changelog entry writer**: takes your recent commits and formats them into release notes.

When your skills need external context (style guides, reference docs, example corpora), add a`references/` subfolder and tell Claude in SKILL.md when to read those files. When you need deterministic processing (data validation, file transformation), add a`scripts/` folder with Python or Node.js files. If you are building skills that integrate with [document automation APIs](https://www.turbodocx.com/products/api-and-sdk), scripts are especially useful for handling structured payloads.

Start with instructions only. Add complexity only when the simple version isn't enough. That order matters.

Want to explore what's already been built?

The community has published hundreds of ready-to-install skills across every domain, from [document generation](https://www.turbodocx.com/products/turbodocx-templating) to [sales workflows](https://www.turbodocx.com/use-cases/sales-teams) to code review.

[See the best Claude Code skills](https://www.turbodocx.com/blog/best-claude-code-skills-plugins-mcp-servers)

![Yacine Kahlerras](https://www.turbodocx.com/images/authors/yacine.jpg)

Yacine Kahlerras•Software Engineer, Platform & UX at TurboDocx

•April 2, 2026•12 min read

## Related Resources

[**Best Claude Code Skills, Plugins & MCP Servers** \\
The skills the community uses most. A curated list of ready-to-install skills across every workflow category.](https://www.turbodocx.com/blog/best-claude-code-skills-plugins-mcp-servers) [**Ship Features in One Session with Claude Code** \\
The workflow methodology for shipping merge-ready features in 45 to 90 minutes, including architectural planning.](https://www.turbodocx.com/blog/how-i-use-claude-code-to-ship-features-in-one-session) [**How to Write CLAUDE.md: Best Practices** \\
The companion to this post. CLAUDE.md is what Claude reads at the project level, skills are what it reads per task.](https://www.turbodocx.com/blog/how-to-write-claude-md-best-practices) [**TurboDocx for Developers** \\
See how developers use the TurboDocx API and SDK to automate document workflows from their own tools.](https://www.turbodocx.com/use-cases/developers)