# Contributing

Contributions are welcome — new skills, new backends, better pipelines, translations, use cases.

---

## Ways to contribute

### Good first issues

- **Add a use case** to [docs/USE_CASES.md](docs/USE_CASES.md) — share a prompt pattern that worked well for you
- **Improve troubleshooting** — if you hit a weird issue and found the fix, add it to [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
- **Translate docs** — we welcome `docs/ru/`, `docs/es/`, etc.
- **Test on a new platform** (Windows native, Linux distros) and report findings

### Meaningful contributions

- **New search backend** — Kagi, Exa, Perplexity API, Brave Search, etc.
- **L2 hardening** — verification checkpoints, scrape enforcement (see issue tracker)
- **Pluggable Codex alternatives** — integrate Gemini CLI or other cross-model channels
- **Obsidian sync formalization** — structured export from L5 vault to Obsidian
- **Plugin marketplace entry** — polish the Claude Code plugin structure for marketplace distribution

### Big ideas

- **L6?** — if you have a principled argument for a tier above L5
- **New composition patterns** — lateral branching, not just vertical depth
- **Shared primitives library** — extract `search → scrape → summarize` as a reusable helper

---

## How to propose changes

### Small changes (typo, clarification, single use case)

Open a PR directly. Keep it focused.

### Medium changes (new backend, new docs section)

1. Open an issue first to discuss approach
2. Wait for a maintainer to 👍 before sinking time into it
3. PR with:
   - Reference to the issue
   - Test evidence (example run output)
   - Updated docs

### Large changes (new skill, architectural refactor)

1. Open an issue as a **proposal** — motivation, design sketch, tradeoffs
2. Get consensus before implementation
3. For new skills: include design for integration with the existing ladder (what does it compose on? what composes on it?)

---

## Repository layout

```
deep-research/
├── README.md            # Main pitch + quickstart
├── LICENSE              # MIT
├── CONTRIBUTING.md      # You are here
├── CHANGELOG.md         # Version history
├── .gitignore           # Critical — never leak research artifacts / keys
├── .env.example         # Template for users to configure their own keys
│
├── skills/              # The six research skills
│   ├── quick-research/
│   ├── research/
│   ├── deep-research/
│   ├── expert-research/
│   ├── academic-research/
│   └── ultra-research/
│
├── docs/                # User documentation
│   ├── INSTALLATION.md
│   ├── USAGE.md
│   ├── USE_CASES.md
│   ├── ARCHITECTURE.md
│   ├── CODEX_INTEGRATION.md
│   └── TROUBLESHOOTING.md
│
├── scripts/             # Install, maintenance
│   └── install.sh
│
└── .firecrawl/
    └── examples/        # Demo research outputs (committed; real examples)
        └── codex-cli-research-agent/
```

---

## Design principles (for new skills / backends)

### Composition, not reinvention

New skills should **compose on top of an existing tier** where possible. Don't re-implement search + scrape + summarize from scratch — call into L1 or L2.

### Artifacts on disk

Every step of a research pipeline writes markdown or JSON to `.firecrawl/research/<slug>/`. Never only keep state in the conversation context.

### Graceful degradation

If an external service (Tavily, Codex, Firecrawl) fails, the skill should **continue with reduced capability** and clearly flag what was missing. Never silently fail.

### Audit trail is sacred

Every claim in a final report must trace back to a file on disk. Hollow synthesis (report cites nothing concrete) is the biggest anti-pattern we actively fight against.

### Explicit cost/time labels

New skills must document their expected:

- Time
- Tavily credits
- Firecrawl scrapes
- Tier in the ladder (where it fits)

Surprises are bad — users need to know what they're paying for.

---

## Coding conventions

### Skill file structure

```markdown
---
name: skill-name
description: One-line description that ends up in the `/` menu
user_invocable: true
---

# Human-readable title

**Position in ladder:** L{N}. Called by L{N+1}. Calls L{N-1}.

## When to use
## When NOT to use
## Budget (time, credits, scrapes)
## Pipeline (numbered steps)
## Artifacts produced
## Examples
```

Keep skill files **under 500 lines**. If longer, extract to `shared/` within the skill's directory.

### Shell commands in skills

Always quote paths, always use absolute paths when writing artifacts:

```bash
# Good
firecrawl scrape "<URL>" --only-main-content -o ".firecrawl/research/<slug>/L1/sources/01-<slug>.md"

# Bad
firecrawl scrape $URL -o $OUTPUT
```

### Naming

- Slugs: `kebab-case`, under 40 chars, no special chars
- Filenames in sources/: `NN-slug.md` where NN is a zero-padded index

---

## Testing a change

Before opening a PR:

1. **Install your version locally:**

   ```bash
   cd deep-research
   bash scripts/install.sh
   ```

2. **Run a full cycle** on whatever skill you changed:

   ```
   /<skill-name> <test query>
   ```

3. **Check artifacts** — open `.firecrawl/research/<slug>/` and verify the expected folder structure exists with non-empty files.

4. **Check the report** — does it cite sources that actually exist? Is confidence grading sensible?

---

## What makes a great PR

- **Small scope** — one concern per PR
- **Clear description** — motivation, approach, tradeoffs
- **Evidence** — example run output, screenshots if UI-adjacent
- **Docs updated** — if behavior changes, docs must change too
- **No secrets** — never commit `.env`, `.claude.json`, or any API key

---

## Security

Found a way to leak credentials or execute unexpected commands? **Don't open a public issue.**

Use GitHub's [private security advisory feature](https://docs.github.com/en/code-security/security-advisories) or email the maintainers (see README for contact).

---

## Community norms

- Be kind. Research tools are used by everyone from students to senior engineers. Don't assume the asker's level.
- **Disagreements are OK, hostility is not.** Challenge ideas, not people.
- Give credit — if a PR built on an issue by someone else, name them.
- **Maintainers are volunteers.** Response time is not a guarantee. If a PR is stale, a polite ping after 2 weeks is fine.

---

## License

By contributing, you agree your work is released under the [MIT license](LICENSE).
