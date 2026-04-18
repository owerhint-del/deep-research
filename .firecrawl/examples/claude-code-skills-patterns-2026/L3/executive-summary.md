# Executive Summary — Claude Code Skills in 2026

**500-word summary for stakeholders. Full report: `L3/report.md`.**

## Bottom line

Claude Code skills are a genuinely useful primitive for specific AI-assisted dev workflows, but the ecosystem is **oversold relative to what independent data supports**. Practitioners should adopt selectively (4-6 role-specific skills, not 20+); enterprises should use the private marketplace with OpenTelemetry governance; regulated-data teams should not rely on skills for production-critical workflows without independent validation.

## What skills are

A **cross-platform file convention** — SKILL.md with YAML frontmatter — published by Anthropic at agentskills.io in December 2025. Same file works in Claude Code, Codex, Cursor, Gemini CLI. Three-level progressive disclosure: metadata always loaded (~100 tokens each), instructions on trigger (<5k tokens), resources executed without loading.

**Note:** "Open standard" overclaims — there is no formal governance body, versioning spec, or independent implementation beyond Anthropic-adjacent platforms. Treat as a shared convention, not a protocol.

## What's shipping

- **Feb 24, 2026:** Cowork private plugin marketplaces for enterprise (admin-controlled via "Customize" menu, per-user provisioning, OpenTelemetry observability, private GitHub repos as sources)
- **Mar 6, 2026:** Public Claude Marketplace + Community Ambassadors program
- **Ecosystem scale:** 1,234+ curated skills in Antigravity's library; `anthropics/skills` 44k+ stars; top skills at 110-117k weekly installs (Firecrawl-reported, unverified independently)
- **Prominent skills:** Frontend Design, Superpowers, Trail of Bits (security), Remotion (React video), Shannon (authorized pentest), Skill-Creator (meta)

## The trust gap nobody emphasizes

- **84% of developers use AI coding tools in April 2026; only 29% trust what those tools ship** [23]
- Typical workflow: "accept the PR, run basic tests, and pray"
- Adoption is real (18% global Claude Code developers, 6× growth in ~7 months) but **marketing-driven, not organically validated**
- Vendor-controlled metrics dominate the data; independent adversarial testing of failure modes remains sparse

## Key limitations

- **Metadata baseline overhead:** ~100 tokens per installed skill × 20 skills = 1,000+ tokens every single request
- **Activation is non-deterministic:** 80%+ reliability with carefully authored trigger-phrase descriptions; 50% baseline without
- **"Description is the trigger"** is the single most important authoring insight; most mistakes are in the description, not the instructions
- **Mega-skills degrade** as they grow — one skill, one job; push context to `references/` subfolder

## Security reality

- **CVE-2025-59536 (CVSS 8.7)** in Claude Code — RCE + API key theft via malicious MCP configs (MCP supply chain — related to but distinct from skill supply chain). Patched.
- **Claudy Day** (Oasis Security, March 2026) — chained Claude.ai vulnerabilities enabled silent data exfiltration. Patched.
- **Meta incident** (March 2026) — AI agent text response led employee to bypass controls; data exposed within 2 hours
- **Sandboxing reduces permission prompts by 84%** (single source, unverified)
- **Prompt injection is OWASP LLM01 for the third year running** — UK cyber agency reportedly suggests it "may never be fixed"

## Enterprise recommendation

Use Cowork private marketplaces with OpenTelemetry for monitoring + private GitHub repos as plugin sources. Admin-curate aggressively. Layer defenses: sandbox + gateway input filtering + Lasso hook + skill-level `allowed-tools` frontmatter.

## When NOT to adopt

- Regulated-data environments (finance, healthcare, legal) where 29% baseline trust is unacceptable without independent testing
- Workflows where non-determinism is unacceptable ("skills do not guarantee execution")
- Teams that would accumulate 20+ skills — role-based bundles of 4-6 are strictly better

## What to watch

- Independent benchmarks of skill reliability (currently absent)
- Public marketplace moderation policy (currently opaque)
- Anthropic's first-mover moat vs cross-platform portability — SKILL.md runs on Codex/Cursor/Gemini CLI equally well
