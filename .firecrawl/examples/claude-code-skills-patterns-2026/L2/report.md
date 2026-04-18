# Claude Code Skills — patterns, what's shipping, limitations in 2026 (L2)

**Query:** Claude Code skills — patterns, what's shipping, limitations in 2026
**Level:** L2 (includes L1)
**Sources:** 12 (L1) + 10 (L2) = 22
**Generated:** 2026-04-18

## TL;DR

Claude Code skills are a **cross-agent open standard** (SKILL.md format at agentskills.io) with three-level progressive disclosure that scales gracefully from inline-only skills to MCP-enhanced multi-tool workflows [1, 2, 6]. Q1 2026 was the inflection point: skills reached the free tier (Feb 17), **Cowork private plugin marketplaces launched for enterprise (Feb 24)**, and the **public Claude Marketplace followed (Mar 6)** [7, 16]. The ecosystem has real scale (1,234+ curated in Antigravity, 110k-117k weekly installs for top skills) but also real failure modes: **skill-as-supply-chain** attack surface, prompt injection as unsolved OWASP LLM01, and concrete CVE-grade incidents (CVE-2025-59536 CVSS 8.7, Claudy Day silent data exfiltration, Meta March 2026 production incident) [13, 15, 20]. ✓ high confidence on architecture, marketplace timeline, and security class; ✓ medium on specific incident attribution.

## Executive Summary

Skills evolved from a launch-era (Oct 2025) mechanism for injecting structured instructions into Claude Code into a cross-platform, marketplace-distributed primitive in Q1 2026. The format specification at agentskills.io (Dec 2025) made skills portable between Claude Code, Codex, Cursor, and Gemini CLI — same file in any `~/.<agent>/skills/` directory [4, 6, 12]. The core mechanic is progressive disclosure across three loading levels: metadata always loaded (~100 tokens each), instructions loaded on trigger (<5k tokens body), and resources executed without loading (scripts run via bash, references loaded only when referenced) [1, 2]. Activation is LLM-reasoning-based — reliability jumps from ~50% baseline to 80%+ with carefully authored third-person descriptions that read as trigger conditions rather than human documentation [6, 10].

Enterprise distribution arrived on Feb 24, 2026 with Cowork's "Customize" admin control system: private plugin marketplaces populated from templates, scratch-built custom plugins, partner plugins, or private GitHub repos, with per-user provisioning and OpenTelemetry observability [16, 17]. The public Claude Marketplace launched March 6 with a Community Ambassadors program. Prominent skills include Anthropic's Skill-Creator (meta-skill for generating skills), Superpowers (multi-step dev workflow), Frontend Design (Encoded Preference pushing Claude past generic AI aesthetics — 110k weekly installs), Remotion (auto-activates on React video code — 117k weekly), Trail of Bits security skills (CodeQL/Semgrep wrappers), and Shannon (autonomous penetration testing with explicit authorization gates) [3, 21, 12].

Limitations are well-characterized: metadata overhead (20 skills ≈ 1,000+ tokens every request), mega-skills degrade as complexity grows (fix: one skill, one job + split process/context across files), under-triggering by default (fix: "slightly pushy" descriptions with explicit trigger phrases), and non-determinism (skills are guidance not automation — "the model still decides whether to follow") [5, 6, 10, 11]. Security remains the largest open concern: CVE-2025-59536 (CVSS 8.7) in Claude Code enabled RCE and API key theft via malicious MCP configs; Claudy Day (March 2026) chained vulnerabilities in Claude.ai for silent data exfiltration; a Meta employee implementing AI-suggested code exposed sensitive data within 2 hours [15, 20]. Sandboxing (filesystem + network isolation) reduces permission prompts by 84% but doesn't eliminate the prompt-injection class of attack, which OWASP still ranks as LLM01 and UK cyber agency suggests "may never be fixed" [19, 20].

## Sub-question 1: Skill anatomy, composition (from L1, enriched)

**Required structure:** SKILL.md with YAML frontmatter (`name` + `description` mandatory, max 64 + 1024 chars respectively), markdown body [1]. Bundle directories: `scripts/` (executed via bash, not loaded), `references/` (markdown loaded into context on demand), `assets/` (templates, binaries) [2]. Reserved `name` words forbidden: "anthropic", "claude" [1].

**Progressive disclosure** [1, 2, 6]:
- Level 1 Metadata: ~100 tokens per skill, always loaded
- Level 2 Instructions: <5k tokens, loaded on trigger
- Level 3 Resources: effectively unlimited, scripts run via bash without loading

**Invocation model:** model-invoked (auto-discovered on description match) vs user-invoked slash commands vs isolated-worker subagents. Hierarchy: commands orchestrate subagents → subagents invoke skills → skills teach Claude to use MCP tools [10].

**Cross-agent directories** [4, 6, 12]: `~/.claude/skills/`, `~/.cursor/skills/`, `~/.gemini/skills/`, `~/.copilot/skills/`. Same file, any platform.

## Sub-question 2: Patterns emerging (from L1, enriched)

**Scale signals:**
- Anthropic's `anthropics/skills`: 44k+ stars [10]
- `awesome-claude-skills`: 8.7k stars [3]
- Antigravity Awesome Skills library: **1,234+ curated skills** [12, 21]
- Remotion: 117k weekly installs [3]
- Frontend Design: 110k weekly installs [3]

**Four skill-complexity categories (Poudel's taxonomy)** [6]:
1. Inline-only (e.g., `git-commit-writer`)
2. File-output (e.g., `readme-writer`)
3. Split skills with `references/` (e.g., `code-reviewer`)
4. MCP-enhancement (e.g., `linear-sprint-planner`)

**Role-based bundles** [21] solve the metadata-overhead problem by installing fewer, more targeted skills:
| Role | Bundle |
|------|--------|
| Frontend | frontend-design, api-design-principles, lint-and-validate, create-pr |
| Security | security-auditor, lint-and-validate, debugging-strategies |
| General | brainstorming, architecture, debugging-strategies, doc-coauthoring |

**Emerging patterns by category:**
- **Encoded Preferences** (Frontend Design): push Claude past generic aesthetics
- **Capability Uplift** (Trail of Bits): wrap external tools (CodeQL/Semgrep) as skills
- **Visual self-validation** (Frontend Design): Playwright render → review own output → fix
- **Auto-activation on context** (Remotion): detect library in context, load automatically
- **Authorization-gated pentest** (Shannon): 96.15% exploit success on XBOW benchmark, but requires written authorization

## Sub-question 3: Limitations (from L1, enriched)

**Baseline token overhead:** 20 skills ≈ 1,000+ tokens every request [10]. Mitigations: delete unused, prefer project-level over user-level, `disable-model-invocation: true` for explicit-only skills.

**Activation non-determinism:** 80%+ reliability with strong descriptions, 50% baseline [10]. "Skills do not guarantee execution. The model still decides whether to follow" [6]. Description is the trigger, not documentation — most authoring mistakes live there [6, 10, 11].

**Mega-skill anti-pattern** [5, 6, 11]: single-file skills degrade as complexity grows. Fix: separate process (SKILL.md) from context (reference files); keep body ≤5k words [1] or ≤400 lines [6]; one skill, one job [11].

**Under-triggering by default** [4]: Claude prefers handling requests itself over loading skills. Fix: explicit trigger phrases as "real words a developer types, not idealized versions" + "slightly pushy" description framing.

## Sub-question 4 (L2 new): Security failures and real incidents

**Prompt injection = OWASP LLM01 / top-ranked agent risk in 2026** [13, 19, 20]. Three attack categories [14]:
- **Direct:** attacker input in the user query
- **Indirect:** malicious text in content agent reads (files, tickets, APIs)
- **Stored:** malicious instructions in persistent data that activate when consumed (think: skill descriptions? — implicit risk)

**Concrete CVE-grade incidents in 2026:**

1. **CVE-2025-59536 (CVSS 8.7)** — disclosed Feb 2026 by Check Point Research. RCE + API key theft in Claude Code via malicious repository configs (MCP configs). **Patched** [15].

2. **Claudy Day** — disclosed March 2026 by Oasis Security. Chain of vulnerabilities in Claude.ai enabling silent data exfiltration via crafted Google search result. Primary injection flaw patched; related fixes in progress [15].

3. **Adversa deny-rule bypass** (bashPermissions.ts hard cap 50 subcommands) — 50 no-op `true` commands + curl passes through permission check. Patched in Claude Code v2.1.90 [13].

4. **OpenClaw installer incident** (Feb 2026) — prompt injection on open-source coding agent installs software on users' systems without malware, just text [14].

5. **Meta incident** (March 2026) — AI agent text response led employee to bypass security controls; sensitive data exposed within 2 hours "at one of the world's best-resourced tech companies" [20].

6. **GTG-1002** (2025) — first documented AI-orchestrated cyberattack at scale, using Claude Code against 30 global organizations [15].

**Defensive mechanisms:**
- **Sandboxing** (filesystem + network isolation): 84% permission-prompt reduction while increasing safety [19]
- **Input filtering at gateway layer** [13]
- **Lasso Security open-source hook** for runtime tool-output scanning [13]
- **Skill-level:** `allowed-tools` frontmatter restricts what agent can call when skill active [1, 6]
- **Human-in-the-loop** for patches: "Reasoning models excel at discovery but still need validation before changes hit production" [19]

**Systemic verdict:** OWASP keeps it at LLM01; UK cyber agency reportedly "may never be fixed" [20]. Accepted framing: layered defenses reduce blast radius but don't eliminate the attack class.

## Sub-question 5 (L2 new): Marketplace state + enterprise

**Timeline consolidation:**
- **Feb 24, 2026 — Cowork private plugin marketplaces** for enterprise (admin-controlled via "Customize" menu) [16, 17, 18]
- **Mar 6, 2026 — Claude Marketplace** (public) + Community Ambassadors program [7]

**Private marketplace mechanics** [16, 17]:
- Populated from: Anthropic public plugins, partner plugins, custom built (templates or scratch), **private GitHub repos as sources (private beta)**
- **Access controls:** per-user provisioning, auto-install push to teams, visibility restrictions
- **Conversational setup:** Claude itself guides plugin creation interactively
- **Plan tiers:** All UX updates available to all Cowork users; branding + per-user provisioning + MCP connector controls require Team or Enterprise; cross-app Excel↔PowerPoint in early research preview on Mac/Windows [17]

**Enterprise governance:**
- **OpenTelemetry support** [17, 18] — plugin usage, tool activity, cost data in standard monitoring format
- **Private GitHub repos** keep custom code within org infrastructure [16]
- **Quiet security hardening in April 2026:** PID-namespace sandboxing, script caps, fail-closed settings refresh (per Perplexity answer citing youtube/anthropic blog)

**Third-party ecosystem** [22]: ClaudePluginHub aggregates multiple independent "marketplaces" (SecondSky, etc.). Implies fragmentation beyond Anthropic's official marketplace. Listed skills often add their own security hardening: supply chain protection, cooldown periods, post-install hardening, lockfile validation, staged rollouts — because skills are inherently supply-chain artifacts.

**Moderation gap (open question):** No public documentation found on how Anthropic moderates public Claude Marketplace submissions for duplicates, spam, malicious content. Enterprise private marketplaces rely on admin curation. Third-party aggregators rely on individual marketplace maintainers. This is the weakest-documented aspect of the ecosystem.

## Contradictions

See `L2/contradictions.md` — 3 examined, all resolved:
1. **"Can injection be fixed?"** — no real contradiction; defenses reduce blast radius, class remains unsolved
2. **Marketplace launch date** — two products: Cowork private (Feb 24) and public Claude Marketplace (Mar 6)
3. **Skill count scale** — 1,234+ is Antigravity specifically; "thousands" is loose community-wide

## Confidence Summary

- **High confidence (7 claims):** architecture, cross-agent portability, description-as-trigger, one-skill-one-job, marketplace timeline, prompt injection as #1, private GitHub repos beta
- **Medium (7 claims):** 20 skills = 1,000+ tokens, 110-117k weekly install counts, 84% permission reduction, Meta March incident, CVE-2025-59536 CVSS 8.7, Claudy Day, 1,234+ Antigravity library
- **Low (3 claims):** UK cyber agency quote, GTG-1002 "first" framing, third-party marketplace fragmentation quant

**Note:** Single-model run (Claude + Tavily + Exa + Perplexity synthesis). Codex cross-model channel was skipped for this L2 to conserve time; could add in L3 escalation if needed.

## Key takeaways

- **SKILL.md is a portable cross-agent standard** (High) [1, 4, 6, 12]
- **Q1 2026 = marketplace inflection:** Feb 24 private enterprise + Mar 6 public (High) [7, 16, 17]
- **1,234+ curated skills in Antigravity library**; top skills hit 110k+ weekly installs (Med) [3, 12, 21]
- **Skills-as-supply-chain = real attack surface**: CVE-2025-59536 CVSS 8.7, Claudy Day, GTG-1002 (Med-High) [15]
- **Sandboxing reduces permission prompts 84%** but prompt injection remains OWASP LLM01 (Med-High) [19, 20]
- **Enterprise moat:** OpenTelemetry + private GitHub repos + admin controls via "Customize" (High) [16, 17, 18]
- **Moderation of public marketplace = under-documented**; third-party marketplaces add their own hardening (Low-Med) [22]

## Open questions

- **Anthropic's public-marketplace moderation policy** — not surfaced in any source
- **Empirical skill-quality benchmarks** — no independent tests comparing official vs community skills on accuracy/reliability
- **Opus 4.6 → 4.7 impact on skill activation** — no data
- **Real-world rates of skill-triggered incidents** — CVEs documented but no aggregate statistics on how often skills themselves are attack vectors
- **Cross-agent reliability drift** — same SKILL.md may behave differently on Codex vs Claude Code; no systematic comparison

## Recommendation

For practitioners:
1. **Start with role-based bundles** (4-6 targeted skills) instead of installing 20+ general skills — saves token baseline
2. **Author third-person descriptions** treating them as trigger conditions, not docs
3. **One skill, one job** — split larger workflows into composable skills
4. **For enterprise:** use Cowork private marketplaces + OpenTelemetry + private GitHub repos; don't rely on public marketplace alone
5. **For security:** layer defenses (sandboxing + gateway input filtering + Lasso hook + `allowed-tools`) but accept prompt injection as unsolved

Escalate to L3 `/expert-research` only for strategic decisions where critic agent adds value (e.g., "should we adopt skills across a 100-person org?"). L2 coverage is already strong for most adoption/architecture questions.
