---
name: research
description: Standard deep research (L1) with planner decomposition and per-source summarization. ~5 min, 10-15 sources, structured ~1000 word report. Default choice for "расскажи про X", "как работает Y", "что нового в Z". Use this when /quick-research is too shallow and /deep-research is overkill.
user_invocable: true
---

# Research — L1 Base Deep Research

Standard research tier. Adds **Planner** (query decomposition) and **per-source summarization** on top of `quick-research`. This is the true foundation of the L1–L5 ladder — every higher level calls this one first, then layers on more.

**Position in ladder:** L1. Called by L2 (`deep-research`), L3, L4, L5 as the first stage.

## When to Use

- "расскажи про X", "что такое Y", "как работает Z" — non-trivial but not strategic
- Technical overviews of a framework, library, concept
- "что нового в X в 2026"
- Default when user asks for research without specifying depth

**Escalate to higher levels if:**
- User wants comparison → `/deep-research` (L2) or `/expert-research` (L3)
- User wants strategic decision → `/expert-research` (L3)
- User wants academic rigor → `/academic-research` (L4)
- User wants a knowledge base → `/ultra-research` (L5)

## Budget

- Time: ~5 min
- Tavily credits: ~20
- Sub-questions: 3
- Sources scraped: 10–15
- Output: structured report ~1000 words

## Pipeline

```
1. CLARIFY     — skip if query is clear
2. PLAN        — decompose into 3 sub-questions
3. SEARCH      — parallel search for each sub-question
4. READ        — scrape 10-15 most relevant sources
5. SUMMARIZE   — per-source summary files
6. SYNTHESIZE  — structured report from summaries
7. SOURCES     — annotated bibliography
```

## Artifacts Directory

Create a single session folder:
```
.firecrawl/research/<slug>/L1/
├── plan.md              # planner output (sub-questions)
├── sources/
│   ├── 01-<slug>.md     # full scrape
│   ├── 01-<slug>.sum.md # 300-500 word summary
│   ├── 02-...
│   └── ...
├── report.md            # final synthesized report
└── bibliography.md      # annotated sources
```

Use a URL-safe slug from the query (e.g., `nextjs-edge-runtime`).

## Step 1: CLARIFY

If query is clear, skip. Otherwise ONE question max, then proceed.

Clear enough to proceed:
- "расскажи про Drizzle ORM"
- "как работает Tavily Research API"
- "что нового в Bun 2.0"

Needs clarification:
- "расскажи про auth" → ask: какая именно auth, для какого стека?
- "исследуй маркетплейсы" → ask: b2c/b2b, регион, вертикаль?

## Step 2: PLAN (Planner decomposition)

Decompose the query into **exactly 3 sub-questions** that together cover the topic. Save to `plan.md`.

**Decomposition heuristics:**
- **"Что такое X" → What, How, Why/When**
  - What is X? (definition, components)
  - How does X work? (mechanism, architecture)
  - When/why to use X? (use cases, trade-offs, alternatives)
- **"Как работает X" → Overview, Internals, Gotchas**
- **"Что нового в X" → Changes, Breaking, Migration**
- **"X vs Y" — use `/deep-research` instead, L1 is not for comparisons**

Write `plan.md`:
```markdown
# Research plan: <query>

**Session:** <slug>
**Level:** L1
**Created:** <date>

## Sub-questions
1. <subq1>
2. <subq2>
3. <subq3>

## Search strategy
- subq1 → [english query, russian query if applicable]
- subq2 → [...]
- subq3 → [...]
```

## Step 3: SEARCH (parallel per sub-question)

Run ALL searches in parallel in ONE message (Bash calls + Tavily MCP calls together).
**v0.9.0:** every Firecrawl search runs with `--scrape --scrape-formats markdown,summary` —
this returns clean markdown **plus an AI-generated summary** per result in a single call,
saving us a separate scrape round in Step 4 for results we end up using.

For each sub-question:
```bash
firecrawl search "<subq1 refined>" \
  --limit 5 \
  --scrape \
  --scrape-formats markdown,summary \
  --only-main-content \
  --json \
  -o .firecrawl/research/<slug>/L1/search-1.json
firecrawl search "<subq2 refined>" \
  --limit 5 \
  --scrape \
  --scrape-formats markdown,summary \
  --only-main-content \
  --json \
  -o .firecrawl/research/<slug>/L1/search-2.json
firecrawl search "<subq3 refined>" \
  --limit 5 \
  --scrape \
  --scrape-formats markdown,summary \
  --only-main-content \
  --json \
  -o .firecrawl/research/<slug>/L1/search-3.json
```

For freshness-sensitive sub-questions, add `--tbs qdr:m` (past month) or `--tbs qdr:y`
(past year). For academic sub-questions, add `--categories research,pdf` (arXiv/Nature/
IEEE/PubMed).

Plus Tavily for each (diversity provider — different index, different top results):
```
mcp__tavily__tavily_search with:
  query: <subq>
  max_results: 5
  search_depth: "advanced"
  topic: "general"          # use "news" if sub-q is freshness-sensitive
  # time_range: "month"     # add for freshness-sensitive sub-qs
```

> **v0.2.2: persist Tavily results.** Tavily goes through MCP — its output lives in conversation context by default, not on disk. After each `mcp__tavily__tavily_search` call, use the Write tool to save the returned JSON (or the full result object) to `.firecrawl/research/$SLUG/L1/tavily-N.json` where N matches the sub-question index. Without persistence, Tavily findings disappear after context compaction and can't be audited.

**Search query refinement rules:**
- Add year ("2026") for freshness-sensitive topics
- For Russian-language topics: one query in Russian + one in English
- For technical libraries: include library name + specific aspect
- Avoid generic queries — be specific

## Step 4: READ (10–15 sources, mostly already-scraped)

Combine results from all searches, deduplicate by URL, rank by:
1. Official docs (highest priority)
2. Authoritative sources (known tech blogs, framework maintainers)
3. Recent (2025–2026)
4. Community with real experience (HN, Reddit, GitHub discussions)

Pick **10–15 sources total** (roughly 3–5 per sub-question).

**v0.9.0 — most picks already have content.** Because Step 3 ran search with
`--scrape --scrape-formats markdown,summary`, the JSON files at
`L1/search-N.json` already contain the full `markdown` and an AI-generated `summary`
per Firecrawl result. Extract them per chosen URL into the source files:

```bash
# For each picked Firecrawl-result URL, write the markdown to L1/sources/.
# Firecrawl --json response shape: { "data": { "web": [ {url, title, markdown, summary, ...} ] } }
# Adjust the search-N.json index based on which search file the URL came from.
mkdir -p .firecrawl/research/<slug>/L1/sources
jq -r --arg url "<picked-url>" \
   '.data.web[] | select(.url == $url) | .markdown' \
   .firecrawl/research/<slug>/L1/search-1.json \
   > .firecrawl/research/<slug>/L1/sources/01-<slug>.md
```

To extract the AI-generated summary alongside (used as starting point for `.sum.md`):

```bash
jq -r --arg url "<picked-url>" \
   '.data.web[] | select(.url == $url) | .summary' \
   .firecrawl/research/<slug>/L1/search-1.json
```

For picks that came from Tavily-only (no Firecrawl scrape) OR for any URL where
Step 3's combined scrape was insufficient, fall back to a targeted scrape:

```bash
firecrawl scrape "<url>" --only-main-content -o .firecrawl/research/<slug>/L1/sources/05-<slug>.md
```

**Optional v0.9.0 alternative — query-focused extraction.** If the URL is huge (e.g.
a long doc page) and only one section is relevant to the sub-question, use
`tavily extract` with a query filter to grab only relevant chunks (cheaper context):

```bash
tvly extract "<url>" --query "<sub-question or specific aspect>" \
  --chunks-per-source 3 --json
```

**Skip these:**
- Paywalled content (NYT, WSJ, Medium paywall)
- SEO spam / thin affiliate pages
- Very old (pre-2023) unless historical context needed
- Translated machine-gen content

## Step 5: SUMMARIZE (per-source, MANDATORY)

**This is the key difference from L0.** Each source gets its own summary file BEFORE synthesis.

For each scraped file, write a companion `.sum.md` file with this exact structure:

```markdown
# Source 01: <title>
**URL:** <url>
**Type:** [official-docs | tech-blog | community | news | academic]
**Date:** <publication date if available>
**Quality:** [A | B | C]  <!-- A=primary/authoritative, B=solid secondary, C=supplementary -->
**Relevant to:** [subq1 | subq2 | subq3]

## Key facts
- Fact 1 (specific, citable)
- Fact 2
- ...

## Key quotes
> "exact quote 1"
> "exact quote 2"

## Notes
- Contradicts source X on Y (if applicable)
- Confirms source X on Z
- Gap: doesn't address W
```

Target: **300–500 words per summary**. Extract facts, numbers, specific claims. Avoid generic statements.

**v0.9.0 helper.** If the source came from Firecrawl search-with-scrape (Step 3),
the search JSON already contains an AI-generated `summary` field for that URL. Use it
as a **starting point** for your `.sum.md` (it's typically 100-200 words covering the
main idea). Then enrich it with: specific quotes, numbers, sub-question relevance, and
notes (contradicts/confirms other sources). The Firecrawl `summary` saves the
"what is this page about" boilerplate so the human-written portion focuses on
research-grade extraction.

**Why this matters:** synthesis step will read summaries, not raw scrapes. Keeps context clean, prevents hallucination, enables downstream levels (L2–L5) to work with structured input.

## Step 6: SYNTHESIZE (report from summaries)

Read ALL `.sum.md` files. Produce `report.md`:

```markdown
# <Topic Title>

**Query:** <original query>
**Level:** L1
**Sources:** <count>
**Generated:** <date>

## TL;DR
[2-3 sentences answering the core question directly]

## <Sub-question 1 as section heading>
[Answer grounded in sources. Inline citations [1], [2].]

## <Sub-question 2 as section heading>
[...]

## <Sub-question 3 as section heading>
[...]

## Key takeaways
- Point 1 [1, 3]
- Point 2 [2, 5]
- Point 3 [4]

## Open questions / gaps
- What the sources did NOT answer (honest list)
- Where sources disagreed

## Recommendation
[Concrete, opinionated recommendation if the query implies a decision. Skip if pure information query.]
```

**Rules for synthesis:**
- Organize by theme / sub-question, NOT by source
- Every factual claim MUST have [N] citation
- If sources conflict, note both positions explicitly
- Use specific numbers and quotes, not vague generalities
- Target **800–1500 words** for the main body

## Step 7: SOURCES (bibliography)

Write `bibliography.md`:

```markdown
# Bibliography

1. **[Title]**(URL) — Quality: A | Type: official-docs
   Contribution: primary source for X, confirmed Y
2. **[Title]**(URL) — Quality: B | Type: tech-blog
   Contribution: real-world benchmarks for Z
...
```

## 🛑 FINAL VERIFICATION (before delivering the report)

Run this Bash block. If verification fails, fix the underlying problem — do NOT ship a broken L1 report (downstream L2/L3/L4/L5 depend on it being correct).

**v0.4.0:** verification logic now lives in the shared library at `~/.claude/scripts/lib/verify-research.sh` (installed by `scripts/install.sh`). Skills call it instead of inlining 30+ lines of Bash. Single source of truth for citation regex, size thresholds, and source-pair counting. Fixing a check in one place updates every tier.

```bash
SLUG="<slug>"                  # replace with actual slug

# Locate the shared verification library.
# Prefer the installed copy; fall back to repo-local if running without install.sh.
VERIFY_LIB="$HOME/.claude/scripts/lib/verify-research.sh"
[ -f "$VERIFY_LIB" ] || VERIFY_LIB="scripts/lib/verify-research.sh"
[ -f "$VERIFY_LIB" ] || { echo "❌ verify-research.sh not found — run scripts/install.sh first"; exit 1; }

source "$VERIFY_LIB"
verify_l1 "$SLUG" || exit 1
```

**Only deliver the report to the user after this prints `✅ L1 VERIFIED`.**

The `verify_l1` function checks: plan exists; report ≥700 words; bibliography present; ≥10 scrape+summary pairs; each source ≥500 bytes; every `[N]` citation (including multi-cite `[1, 3, 16]`) maps to a bibliography entry.

## Final output to user

1. Display `report.md` content in chat
2. Mention artifact location: `Файлы в .firecrawl/research/<slug>/L1/`
3. Offer next steps:
   > Нужно глубже? `/deep-research` (L2) добавит reflection и проверку противоречий.
   > Нужна строгая проверка? `/expert-research` (L3) добавит critic-агент и fact-check.

## Rules

- **Always planner first** — never skip Step 2. This is what makes L1 ≠ L0.
- **Always per-source summaries** — never skip Step 5. Downstream levels depend on it.
- **Parallel everything** — searches and scrapes run concurrently in one message
- **Cite everything** — no claims without [N] reference
- **Flag conflicts** — explicit "source A says X, source B says Y"
- **Russian / English** — match user's query language in output
- **No hallucinations** — if sources don't answer it, say "not found in sources"
- **Leave artifacts** — keep files, don't clean up automatically (unlike L0)

## Called from higher levels

When L2/L3/L4/L5 call this skill, they:
1. Execute the full L1 pipeline
2. Read `report.md` and all `.sum.md` files as input for their additional layers
3. Do NOT duplicate L1 work

This means L1 must produce **clean, structured, self-contained output** that downstream levels can build on.
