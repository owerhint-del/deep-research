# Usage Guide

How to invoke each tier of the research ladder, what it produces, and how to pick the right one.

---

## TL;DR — picking a tier

```
        ┌─────────────────────────────────────────────────┐
        │ "What's the latest version / who / when / is X" │─────→ L0 /quick-research
        └─────────────────────────────────────────────────┘

        ┌─────────────────────────────────────────────────┐
        │ "Explain X" / "How does Y work" / "What's new"  │─────→ L1 /research
        └─────────────────────────────────────────────────┘

        ┌─────────────────────────────────────────────────┐
        │ "X vs Y" / "Should we migrate" / "Non-trivial"  │─────→ L2 /deep-research
        └─────────────────────────────────────────────────┘

        ┌─────────────────────────────────────────────────┐
        │ "Strategic decision" / "Tech migration pros/cons"│────→ L3 /expert-research
        └─────────────────────────────────────────────────┘

        ┌─────────────────────────────────────────────────┐
        │ "Literature review" / "Scientific overview"      │────→ L4 /academic-research
        └─────────────────────────────────────────────────┘

        ┌─────────────────────────────────────────────────┐
        │ "Full knowledge base" / "Become an expert"       │────→ L5 /ultra-research
        └─────────────────────────────────────────────────┘
```

**Rule of thumb:** start one tier below what you think you need. Upgrade only if output is insufficient.

---

## L0 — `/quick-research`

### What it is

The fastest tier — a web-search-powered fact-check with citations. No full scrapes, no per-source summaries.

### When to use

- Version numbers, release dates
- "Who said what" references
- "Is X available in Y?" quick lookups
- Pre-research scouting before committing to a deeper tier

### When NOT to use

- Anything requiring synthesis across sources
- Anything you'd use as input for a decision
- Multi-faceted questions

### Example prompts

```
/quick-research latest stable version of Bun
/quick-research when did Anthropic release Claude 4.7
/quick-research does Next.js 15 support Turbopack in production
/quick-research GPT-5.4 release date
```

### Output

Short paragraph (50–150 words) with inline citations, finished with a `Sources:` block listing 3–5 URLs.

### Artifacts

None. Runs in your main conversation — no `.firecrawl/research/` folder created.

### Time / cost

~1 minute. ~10 Tavily credits. Zero Firecrawl cost.

---

## L1 — `/research`

### What it is

The **foundation tier**. Adds query decomposition (planner) and per-source summaries on top of L0.

This is also what every higher tier calls first. When you run L3, it starts by running L1 internally.

### When to use

- "Explain X to me" topics where you want structure
- "What's new in X in 2026"
- Getting up to speed on an unfamiliar framework/library/concept
- Default when the user hasn't specified depth

### Example prompts

```
/research how does Tailwind CSS v4 differ from v3
/research current state of Rust web frameworks
/research what is Model Context Protocol
/research how do transformer models handle long context
```

### Pipeline

1. **CLARIFY** — if the query is ambiguous, Claude asks once
2. **PLAN** — decompose into 3 sub-questions
3. **SEARCH** — parallel Firecrawl + Tavily queries per sub-q
4. **READ** — scrape top 10–15 URLs with `firecrawl scrape --only-main-content`
5. **SUMMARIZE** — one `.md` per source: title, key findings, citations
6. **REPORT** — ~1,000-word structured synthesis with bibliography

### Artifacts

```
.firecrawl/research/<slug>/L1/
├── plan.md              # Sub-questions
├── search-1.json        # Raw results for sub-q 1
├── search-2.json
├── search-3.json
├── sources/             # Full scrapes (10–15 .md files)
├── summaries/           # Per-source digests
└── report.md            # Final synthesis
```

### Time / cost

~5 min. ~20 Tavily credits. 10–15 Firecrawl scrapes.

---

## L2 — `/deep-research`

### What it is

Adds a **reflection loop** on top of L1. After L1 produces its report, L2:

1. Analyzes gaps in the report
2. Writes 2 follow-up sub-questions
3. Runs a second round of searches + scrapes
4. Surfaces contradictions between sources
5. Grades every claim with confidence (H/M/L)

### When to use

- `X vs Y` comparisons
- "Should we migrate from A to B"
- Non-trivial technical questions where one pass might miss nuance
- Default for "подробно", "serious", "deep"

### Example prompts

```
/deep-research PostgreSQL vs MongoDB for multi-tenant e-commerce
/deep-research should we migrate from Webpack to Vite on a 300-component monorepo
/deep-research state of Telegram Ads for gaming apps in 2026
/deep-research Zustand vs Jotai vs Redux Toolkit for a React team new to state management
```

### Additional artifacts (on top of L1)

```
.firecrawl/research/<slug>/L2/
├── gaps.md              # Reflection output — what L1 missed
├── plan.md              # Follow-up sub-questions
├── sources/             # New scrapes (10–15 new .md)
├── summaries/
├── contradictions.md    # Disagreements between sources
└── report.md            # ~2,000-word synthesis, claims graded H/M/L
```

### Time / cost

~12 min total (L1: ~5 + L2 layer: ~7). ~50 Tavily credits. 20–30 Firecrawl scrapes.

---

## L3 — `/expert-research`

### What it is

Adds an **independent critic agent** and a **neutral-angle researcher** on top of L2.

After L2 finishes, L3 spawns:

1. **Critic agent** — reads the L2 report adversarially, challenges conclusions, checks for missing angles
2. **Neutral-angle researcher** — does a fresh search with intentionally different framing
3. **Human-in-the-loop checkpoint** (optional) — approve the plan before expensive phase

### When to use

- Strategic decisions (significant cost of being wrong)
- Technology migrations affecting the whole team
- Investigations where you need a second set of eyes
- "Important" marked queries

### Example prompts

```
/expert-research should our 20-person team move from REST to GraphQL federation
/expert-research is Rust the right language for our new data pipeline service
/expert-research Kubernetes vs Nomad for a 5-service startup in 2026
```

### Additional artifacts (on top of L1 + L2)

```
.firecrawl/research/<slug>/L3/
├── critic-review.md     # Adversarial pass on L2 report
├── neutral-angle.md     # Fresh perspective findings
└── report.md            # 3,000-word executive report
```

### Time / cost

~20 min total. ~100 Tavily credits. 40–60 Firecrawl scrapes.

---

## L4 — `/academic-research`

### What it is

Adds an **academic sources layer** (arXiv, Google Scholar, DOI-backed papers) and a **full multi-agent crew** on top of L3.

Agent crew:

- **Planner** — orchestrates sub-questions
- **Researcher A** — general web sources
- **Researcher B** — academic databases
- **Critic** — adversarial review
- **Editor** — final synthesis

Output includes a **timeline analysis** and **annotated bibliography with source quality ratings**.

### When to use

- Scientific overviews
- Literature reviews
- Research-grade investigations with citation integrity
- When source credibility matters for downstream use

### Example prompts

```
/academic-research MoE architectures in LLMs 2023-2026
/academic-research remote work productivity research methodologies
/academic-research evidence for and against psychological safety in engineering teams
/academic-research retrieval-augmented generation benchmarks landscape
```

### Additional artifacts

```
.firecrawl/research/<slug>/L4/
├── academic-sources/    # arXiv/Scholar scrapes
├── timeline.md          # Chronological synthesis of the field
├── annotated-bibliography.md   # Each source with quality rating
└── report.md            # ~5,000-word report with methodology section
```

### Time / cost

~40 min. ~300 Tavily credits. 80–120 Firecrawl scrapes.

---

## L5 — `/ultra-research`

### What it is

The **maximum-depth tier**. Builds a complete knowledge vault with:

- Executive summary
- Glossary
- Timeline
- Playbooks (how-to guides extracted from findings)
- Counter-arguments
- Open questions
- Recursive exploration until **knowledge saturation** (stops only when follow-up queries return no new facts)
- Peer-review simulation between agents
- Full agent crew (7+ roles)

### When to use

- You want to become an expert on the topic
- Building internal wiki / onboarding material
- Long-term reference docs

### Example prompts

```
/ultra-research MCP protocol — complete knowledge vault for our team
/ultra-research everything about prompt caching in Claude API for production apps
/ultra-research full landscape of AI agent orchestration frameworks
```

### Artifacts

Full vault structure:

```
.firecrawl/research/<slug>/L5/
├── executive-summary.md
├── glossary.md
├── timeline.md
├── playbooks/
│   ├── how-to-<task-1>.md
│   └── how-to-<task-2>.md
├── counter-arguments.md
├── open-questions.md
├── annotated-bibliography.md
└── report.md            # 10,000+ word main report
```

Also auto-syncs to your Obsidian vault if configured.

### Time / cost

1+ hour. ~800 Tavily credits. 150+ Firecrawl scrapes.

---

## Tips and patterns

### Pattern: scout then deep-dive

```
/quick-research what is CRDT                  # L0 — is this relevant to us at all?
/research CRDT implementations in JavaScript  # L1 — if yes, get overview
/deep-research Yjs vs Automerge for a collaborative editor   # L2 — pick between two
```

Each tier costs more. Scouting with L0 first prevents burning L3 on something you'll discard.

### Pattern: parallel exploration

If you have multiple unrelated questions, run them in separate Claude Code sessions rather than chaining. Each gets its own `.firecrawl/research/<slug>/` folder.

### Pattern: reuse artifacts

The `.firecrawl/research/<slug>/` folder is just markdown + JSON. You can:

- Commit it to a project wiki
- Feed it back into Claude as context for follow-ups: `"here are our research findings from research/L2/report.md, now help me write an RFC"`
- Share with teammates — the audit trail is fully portable

### Pattern: upgrade mid-flight

If L2 output feels insufficient, you can escalate:

```
/expert-research <same query>
```

L3 reuses L1/L2 artifacts if they exist in the same slug folder, only running the L3 layer on top.

---

## Troubleshooting usage

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Report cites sources but `.firecrawl/.../sources/` is empty | L2 skipped scrape step | Re-run; see [TROUBLESHOOTING.md](TROUBLESHOOTING.md#l2-hollow-synthesis) |
| Tavily "rate limit" errors | Free tier exhausted | Wait for monthly reset or upgrade |
| Codex channel timing out | Heavy weekly usage | Disable Codex temporarily, see [CODEX_INTEGRATION.md](CODEX_INTEGRATION.md) |
| Wrong language in report | Claude auto-detects from query | Add `"respond in English"` / `"отвечай по-русски"` to the prompt |

Full issue catalog: [docs/TROUBLESHOOTING.md](TROUBLESHOOTING.md).
