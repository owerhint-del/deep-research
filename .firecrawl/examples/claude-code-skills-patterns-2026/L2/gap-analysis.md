# Gap Analysis

**Based on:** L1/report.md (12 sources, 1189 words)

## Unanswered in L1

- **Empirical skill failure modes** — L1 lists conceptual limitations but doesn't have concrete war stories ("we shipped a skill and it broke production because X")
- **Community vs official skill quality** — no empirical benchmark comparing official Anthropic skills vs top community picks
- **Marketplace moderation** — how does Anthropic (or the community) handle duplicate/spam/malicious skills?
- **Private plugin marketplaces for enterprise** — what specifically makes them different from public (admin controls, air-gap, etc.)

## Shallow coverage

- **MCP + Skills interaction** — mentioned as "skills teach how to use MCP tools" but no deep-dive on MCP-enhancement skills
- **Cost of activation failures** — we have the 80% vs 50% activation number but no picture of what "failure" means in practice
- **Model upgrade impact** — Opus 4.6 (Feb 5) vs Sonnet 4.6 (Feb 17) — did skill behavior change notably?

## Missing perspectives

- **Enterprise skill adoption** — real org stories (apart from high-level Rakuten mention)
- **Claude Code security concerns** with skills (execution, prompt injection via skill description)
- **Critics of the skill model** — has anyone written "why the SKILL.md pattern is wrong"?

## Unverified claims

- "20 skills = 1,000+ tokens" — single source [10]; is this accurate?
- "117k weekly installs for Remotion, 110k for Frontend Design" — Firecrawl's own data, vendor bias possible
- "anthropics/skills 44k+ stars" — cited in one secondary source [10]; verify directly
- "80% activation reliability vs 50% baseline" — where does this measurement come from?
