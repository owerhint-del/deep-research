# Deep Research — Systematic Research Ladder for Claude Code

> **Six composable research skills (L0→L5).** From a 60-second fact-check to a 40-minute academic-grade investigation with 120+ sources. Pick the right depth for the task.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-blue.svg)](https://claude.com/claude-code)
[![Status](https://img.shields.io/badge/status-v0.1.1-orange.svg)]()
[![Русский](https://img.shields.io/badge/lang-Русский-red.svg)](README.ru.md)

---

## What is this?

A set of six [Claude Code](https://claude.com/claude-code) skills that form a **research ladder**. Each tier composes on top of the previous one, adding specific capabilities:

| Tier | Skill | Time | Sources | Output | Best for |
|:----:|-------|:----:|:-------:|--------|----------|
| **L0** | `/quick-research` | ~1 min | 3–5 | 1-paragraph answer with citations | Fact-checks, simple lookups, "latest version of X" |
| **L1** | `/research` | ~5 min | 10–15 | ~1,000-word structured report | Standard overviews, "how does X work" |
| **L2** | `/deep-research` | ~12 min | 20–30 | ~2,000-word report + contradictions | Tech choices, comparisons, non-trivial investigations |
| **L3** | `/expert-research` | ~20 min | 40–60 | ~3,000-word report + critic review | Strategic decisions, technology migrations |
| **L4** | `/academic-research` | ~40 min | 80–120 | ~5,000-word report with bibliography | Research-grade, scientific overviews |
| **L5** | `/ultra-research` | 1+ hour | 150+ | Full knowledge vault (10,000+ words) | Become an expert on a topic |

**Key property:** L3 calls L2 which calls L1. Every higher level inherits the foundation and adds its own layer (reflection, critic, multi-perspective, academic sources, recursive loops).

---

## Why does this exist?

LLM-assisted research suffers from three chronic problems:

1. **Shallow by default** — ad-hoc "search the web" gives you 1–2 sources and confident-sounding synthesis with no verification.
2. **Hollow synthesis** — the output *sounds* authoritative, but there is no audit trail. You can't trace a claim back to a source.
3. **Context bloat** — pouring research into your main conversation bloats the context window and degrades later tool use.

This ladder solves each:

| Problem | Solution |
|---------|----------|
| Shallow by default | Tiered depth — pick L0 for a lookup, L4 for a literature review |
| Hollow synthesis | Every L1+ scrapes full content, writes per-source summaries, grades confidence |
| Context bloat | All artifacts live in `.firecrawl/research/<slug>/` — the main chat stays clean |

---

## Quick Start

### Prerequisites

**Required:**

- [Claude Code](https://claude.com/claude-code) CLI (any recent version)
- [Firecrawl CLI](https://www.firecrawl.dev) — scraping engine
- [Tavily MCP](https://tavily.com) — search API (free tier works)

**Optional (L2+ cross-model channel):**

- [OpenAI Codex CLI](https://developers.openai.com/codex/cli) + ChatGPT Pro subscription

Full setup: see [docs/INSTALLATION.md](docs/INSTALLATION.md).

### Install

```bash
git clone https://github.com/YOUR_USERNAME/deep-research.git
cd deep-research
bash scripts/install.sh
```

The script copies `skills/*` into `~/.claude/skills/` and prints next-step instructions for API keys.

### First run

```
/quick-research latest stable version of Bun
/research how does Tailwind CSS v4 differ from v3
/deep-research PostgreSQL vs MongoDB for an e-commerce platform in 2026
```

That's it. Each skill writes its artifacts to `.firecrawl/research/<slug>/` in whatever directory Claude Code is currently running in.

---

## How it works

Each skill is a markdown file that Claude Code loads as instructions. When you invoke a skill, Claude follows its pipeline:

```
L3 Expert Research
  └─ calls L2 Deep Research
       └─ calls L1 Base Research
            ├─ 1. Plan     — decompose query into 3 sub-questions
            ├─ 2. Search   — parallel Firecrawl + Tavily for each sub-q
            ├─ 3. Scrape   — full page content, one file per URL
            ├─ 4. Summarize— per-source .md summary (title, findings, citations)
            └─ 5. Report   — ~1,000-word synthesis with bibliography
       ├─ 6. Reflection    — find gaps in L1 report
       ├─ 7. Follow-up     — 10–15 new sources for gaps
       ├─ 8. Contradiction — surface disagreements between sources
       └─ 9. Confidence    — grade each claim H/M/L
  ├─ 10. Critic agent      — independent pass, challenges conclusions
  ├─ 11. Neutral angle     — fresh perspective search
  └─ 12. Executive summary — 3,000-word final report
```

Artifact layout after an L3 run:

```
.firecrawl/research/postgres-vs-mongo-2026/
├── L1/
│   ├── plan.md              ← sub-questions
│   ├── search-1.json        ← raw search results
│   ├── sources/             ← full scrapes
│   │   ├── 01-aws-docs.md
│   │   └── 02-mongo-atlas.md
│   ├── summaries/           ← per-source digests
│   └── report.md            ← L1 synthesis
├── L2/
│   ├── gaps.md              ← reflection output
│   ├── sources/             ← new scrapes
│   ├── contradictions.md
│   └── report.md            ← L2 synthesis
└── L3/
    ├── critic-review.md     ← adversarial pass
    ├── neutral-angle.md
    └── report.md            ← final executive report
```

---

## Real use cases

### Software engineering

- **Technology choices** — `/deep-research Next.js vs SvelteKit for our e-commerce startup`
- **Library migration** — `/deep-research migrating from Prisma to Drizzle — breaking changes and gotchas`
- **New release research** — `/research what's new in React 19 and production readiness`
- **Architecture patterns** — `/expert-research should we use CQRS for our multi-tenant SaaS`

### Business & strategy

- **Market analysis** — `/expert-research state of Telegram Ads for gaming apps in 2026`
- **Competitive intel** — `/deep-research how does Linear compare to Jira for 20-person engineering team`
- **Pricing research** — `/research pricing models for B2B AI SaaS in 2025-2026`
- **Regulatory** — `/academic-research EU AI Act compliance for LLM-based products`

### Academic & journalism

- **Literature review** — `/academic-research MoE architectures in LLMs 2023-2026`
- **Fact-checking with trail** — `/deep-research claims about GPT-5.4 BrowseComp 89.3% benchmark`
- **Trend analysis** — `/expert-research rise and decline of crypto-based social networks`
- **Multi-perspective** — `/academic-research remote work productivity studies methodologies`

Full library with example prompts and expected outputs: see [docs/USE_CASES.md](docs/USE_CASES.md).

---

## What's special about this

| Feature | What it gives you |
|---------|-------------------|
| **Composable ladder** | Each tier inherits the full pipeline of tiers below. No copy-pasted logic. |
| **Cross-model verification (L2+)** | Optional Codex CLI channel adds GPT-5.4 as a second, independent research voice. Different search index, different model, fewer blind spots. |
| **Confidence grading** | Every L2+ claim is tagged H/M/L. You know which parts of the synthesis to trust. |
| **Contradiction surfacing** | L2 explicitly writes a `contradictions.md` — no more hidden disagreements between sources. |
| **Critic agent (L3+)** | Separate agent reviews the report adversarially before you see it. |
| **Per-source summaries** | Never lose the audit trail — every cited fact points to a full scrape on disk. |

---

## Documentation

| Doc | What's inside |
|-----|---------------|
| [docs/INSTALLATION.md](docs/INSTALLATION.md) | Full setup on macOS/Linux/WSL, all API keys, verification |
| [docs/USAGE.md](docs/USAGE.md) | Every skill explained with inputs, outputs, and tips |
| [docs/USE_CASES.md](docs/USE_CASES.md) | 20+ real-world scenarios with ready-to-copy prompts |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Design philosophy — why a ladder, why these boundaries |
| [docs/CODEX_INTEGRATION.md](docs/CODEX_INTEGRATION.md) | Optional GPT-5.4 cross-model channel for L2+ |
| [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) | Common issues and fixes |
| [CONTRIBUTING.md](CONTRIBUTING.md) | How to add skills, improve pipelines, open PRs |

---

## Requirements at a glance

| Component | Required? | Free tier? | Notes |
|-----------|-----------|------------|-------|
| Claude Code | Yes | — | Core runtime |
| Firecrawl | Yes | 500 scrapes/mo | For all levels |
| Tavily | L1+ | 1,000 searches/mo | Skip only if you use L0 exclusively |
| Codex CLI | No | Requires ChatGPT Pro | Unlocks L2+ cross-model channel |

Total cost if you stick to free tiers: **$0**. With Codex: existing ChatGPT Pro ($200/mo) — no extra API fees.

---

## Roadmap

- [x] v0.1 — Six-tier research ladder (L0→L5)
- [x] v0.1 — Firecrawl + Tavily integration
- [ ] v0.2 — Codex CLI cross-model channel (L2+)
- [ ] v0.2 — L2 hardening (verification checkpoints, scrape enforcement)
- [ ] v0.3 — Claude Code plugin marketplace distribution
- [ ] v0.3 — Russian documentation (`docs/ru/`)
- [ ] v0.4 — Additional search backends (Kagi, Exa, Perplexity API)
- [ ] v1.0 — Obsidian auto-sync for L5 vaults

See [CHANGELOG.md](CHANGELOG.md) for what's shipped.

---

## Contributing

Contributions are welcome — new skills, new backends, better pipelines, translations. Start with [CONTRIBUTING.md](CONTRIBUTING.md).

Good first issues:
- Improve L2 verification checkpoints (see issue tracker)
- Add a new search backend (Kagi, Exa, Brave Search)
- Write use-case examples for a domain we haven't covered
- Translate docs to your language

---

## License

[MIT](LICENSE) — use freely, modify freely, attribution appreciated but not required.

---

## Credits

Built on top of:

- **[Claude Code](https://claude.com/claude-code)** — Anthropic's CLI
- **[Firecrawl](https://www.firecrawl.dev)** — web scraping engine
- **[Tavily](https://tavily.com)** — research-grade search API
- **[OpenAI Codex CLI](https://developers.openai.com/codex)** — optional cross-model channel

Originally designed by [@owerhint](https://github.com/owerhint) as an internal research toolkit, open-sourced because good systematic research should not be a closely-guarded secret.
