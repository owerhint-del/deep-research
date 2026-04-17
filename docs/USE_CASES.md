# Use Cases Library

20+ real scenarios with ready-to-copy prompts, showing which tier to pick and what you'll get back.

---

## Table of contents

- [Software engineering](#software-engineering)
- [DevOps & infrastructure](#devops--infrastructure)
- [Product & business](#product--business)
- [Marketing & growth](#marketing--growth)
- [Academic & journalism](#academic--journalism)
- [Personal learning](#personal-learning)

---

## Software engineering

### 1. Framework selection

**Scenario:** Starting a new project, weighing two frameworks.

```
/deep-research Next.js vs SvelteKit for a B2B SaaS with SEO requirements in 2026
```

**What you get:** ~2,000-word comparison with dimensions (DX, performance, ecosystem, hiring pool), contradiction-surfaced tradeoffs, confidence-graded claims.

---

### 2. Library migration

**Scenario:** Considering swapping a core dependency.

```
/expert-research migrating from Prisma to Drizzle on a 200-table Postgres schema — breaking changes, effort, gotchas
```

**What you get:** L3 with critic review. Executive summary tells you go/no-go. Critic pass checks the "no-go" arguments.

---

### 3. Understanding a new release

**Scenario:** New major version of a tool you use.

```
/research what's new in React 19 — production readiness, breaking changes, migration path
```

**What you get:** Quick structured overview, perfect for sharing with the team.

---

### 4. Architecture pattern evaluation

**Scenario:** Should we adopt a pattern?

```
/expert-research event sourcing for our billing service — benefits vs complexity for 5-person team
```

**What you get:** L3 — the critic agent explicitly challenges "simple use case" arguments, which is exactly what you want when considering architectural commitment.

---

### 5. Bug root-cause scouting

**Scenario:** Hitting a weird error, wondering if others have seen it.

```
/quick-research "Error: Hydration failed because the initial UI does not match" Next.js 15
```

**What you get:** Fast lookup — if this is a known issue, you find the fix in a minute. If not, escalate to `/research`.

---

## DevOps & infrastructure

### 6. Cloud provider choice

**Scenario:** Deciding where to host a new service.

```
/deep-research Hetzner Cloud vs DigitalOcean vs Hostinger VPS for Node.js API serving 5K req/sec in 2026
```

**What you get:** L2 with contradictions surfaced (pricing claims vary wildly between sources — good that it's flagged).

---

### 7. Database choice

**Scenario:** OLTP database decision for a growing app.

```
/expert-research PostgreSQL vs CockroachDB vs Planetscale for multi-region SaaS at 10K paying customers scale
```

---

### 8. Orchestration tooling

```
/expert-research Kubernetes vs Nomad vs Docker Swarm for a 5-service startup — operational burden and hiring pool
```

---

### 9. CI/CD pipeline choice

```
/deep-research GitHub Actions vs CircleCI vs Depot build performance and cost for monorepo CI in 2026
```

---

## Product & business

### 10. Competitive analysis

```
/expert-research Linear vs Jira vs Shortcut for 20-person engineering team — real user experiences, not vendor claims
```

**Tip:** the phrase "not vendor claims" biases toward forums, reviews, and independent blog posts. L3's neutral-angle agent reinforces this.

---

### 11. Pricing research

```
/deep-research pricing models for B2B AI SaaS in 2025-2026 — usage-based vs seat-based vs hybrid
```

---

### 12. Market sizing

```
/academic-research size and growth of the developer tooling market 2024-2026 with methodology rigor
```

**Why L4:** numbers matter here, and the annotated bibliography gives you source-quality ratings.

---

### 13. Regulatory scan

```
/academic-research EU AI Act compliance requirements for LLM-based SaaS products
```

---

## Marketing & growth

### 14. Channel research

```
/expert-research state of Telegram Ads for gaming/entertainment apps in 2026 — workflow, tools, real CPMs
```

---

### 15. SEO landscape

```
/deep-research how Google AI Overviews changed SEO strategy in 2025-2026
```

---

### 16. Content strategy

```
/research how successful B2B SaaS companies structure their blog in 2026 — cadence, topics, distribution
```

---

### 17. Ad platform deep-dive

```
/expert-research Google Ads vs Meta Ads vs Reddit Ads for developer-tool B2B SaaS — CAC, quality, tooling
```

---

## Academic & journalism

### 18. Literature review

```
/academic-research mixture-of-experts architectures in large language models 2023-2026 — survey
```

**Output:** ~5,000 words with timeline, methodology section, annotated bibliography. Good enough to be a starting point for a paper or internal whitepaper.

---

### 19. Fact-checking with trail

```
/deep-research claims that GPT-5.4 achieves 89.3% on BrowseComp benchmark — primary sources and verification
```

---

### 20. Multi-perspective investigation

```
/academic-research remote work productivity — studies on both sides, methodologies, what the contradictions mean
```

---

### 21. Trend analysis

```
/expert-research rise and decline of crypto-based social networks 2021-2026 — what worked, what didn't, why
```

---

## Personal learning

### 22. New-concept onboarding

```
/research what is Model Context Protocol — developer perspective, not marketing
```

---

### 23. Deep-dive into a specialty

```
/ultra-research full knowledge vault about prompt caching in Claude API — for production engineering team
```

**Output:** Vault with executive summary, glossary, playbooks for common tasks, counter-arguments to common advice, and open questions.

---

### 24. Career-skill research

```
/deep-research what distinguishes senior from staff engineers at product-focused companies in 2026
```

---

### 25. Hobby deep-dive

```
/research home roasting coffee — equipment, beans, technique, realistic expectations
```

---

## Anti-patterns

Some things this ladder is **not** good for:

| Don't use | Why |
|-----------|-----|
| Simple code lookups you can find in docs | Use `mcp__context7__query-docs` — it's designed for this |
| Questions where recent news matters most | L1–L5 prioritize depth over recency — for breaking news use `/quick-research` + check timestamps |
| Questions with one clear authoritative source | If you know the source, just scrape it directly with `firecrawl scrape <url>` |
| Subjective opinion (e.g. "is X code clean") | Research surfaces what sources say, not quality judgments |
| Generating content (blog posts, emails) | Research first, *then* ask Claude to write — don't conflate |

---

## Submitting new use cases

Found a great prompt pattern? Open a PR adding it to this file. See [CONTRIBUTING.md](../CONTRIBUTING.md).
