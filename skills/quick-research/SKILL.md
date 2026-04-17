---
name: quick-research
description: Quick web research for simple questions — fast answer with 3-5 cited sources in ~1 minute. Use for fact-checks, simple lookups, "what is X", "latest version of Y", "who made Z". For anything deeper, use /research (L1) or /deep-research (L2).
user_invocable: true
---

# Quick Research (L0)

Fast lightweight research for simple questions. No planner, no reflection, no multi-agent — just a quick multi-source search with a cited answer.

**Position in ladder:** L0 — the lightest tier. When in doubt between this and `/research`, prefer `/research`.

## When to Use

- Fact checks: "какая последняя версия Next.js", "когда вышел Bun 2.0"
- Simple lookups: "что такое edge runtime", "кто автор библиотеки X"
- Yes/no questions with supporting evidence
- Any question the user frames as "быстро", "коротко", "кратко"

**Do NOT use for:**
- Comparisons (use `/deep-research`)
- Strategic decisions (use `/expert-research`)
- Topics requiring depth (use `/research` or higher)

## Budget

- Time: ~1 min
- Tavily credits: ~5
- Sources read: 3–5
- Output: 2–4 paragraphs with inline citations

## Pipeline

```
1. SEARCH   — one parallel multi-source query
2. READ     — scrape top 3 results
3. ANSWER   — short structured response with citations
```

## Step 1: SEARCH (parallel multi-source)

Run these in PARALLEL in a single message:

```bash
firecrawl search "<query>" --limit 5 --json
```

And Tavily:
```
mcp__tavily__tavily_search with:
  query: <query>
  max_results: 5
  search_depth: "basic"
```

For Russian-language topics: add one extra search in Russian.

## Step 2: READ (scrape top 3)

Pick the 3 most relevant/authoritative results and scrape them IN PARALLEL:

```bash
firecrawl scrape "<url1>" --only-main-content &
firecrawl scrape "<url2>" --only-main-content &
firecrawl scrape "<url3>" --only-main-content &
wait
```

**Source priority:**
1. Official docs / primary sources
2. Recent articles (2025–2026)
3. Authoritative tech sources
4. Skip: SEO spam, affiliate pages, paywalled content

Use `head -80` and `grep` to find relevant sections. Don't read full files.

## Step 3: ANSWER

Format the response as:

```
**[Direct answer in 1-2 sentences]**

[2-3 supporting paragraphs with inline citations [1], [2], [3]]

---
**Sources:**
1. [Title](URL)
2. [Title](URL)
3. [Title](URL)
```

## Rules

- **Always cite** — every factual claim needs [N] reference
- **Direct answer first** — no preamble, no "let me research this"
- **Flag uncertainty** — if sources disagree, say so briefly
- **Freshness** — prefer 2025–2026 sources
- **Language** — match user's language (Russian / English)
- **No artifacts on disk** — this is a quick mode, don't save to `.firecrawl/research/`
- **No clarifying questions** — if query is ambiguous, pick most likely interpretation and answer

## Escalation

If during research you realize the question is more complex than expected (needs comparison, deep analysis, multiple perspectives), STOP and tell the user:

> "Этот вопрос серьёзнее чем quick-research. Рекомендую `/research` (L1) или `/deep-research` (L2). Продолжить quick или переключиться?"
