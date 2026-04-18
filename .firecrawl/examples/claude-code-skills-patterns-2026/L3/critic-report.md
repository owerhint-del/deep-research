# Critic Report

Harsh review of the L2 report on "Claude Code skills — patterns, what's shipping, limitations in 2026."

## Weakest claims in L2 report

- **"Q1 2026 = marketplace inflection"** (TL;DR + Key takeaways). This is a narrative frame, not an empirical finding. Two launches ~10 days apart (Cowork Feb 24, public Marketplace Mar 6) do not by themselves constitute an inflection — no adoption curve, no before/after install-rate delta, no retention numbers. The report names the event but never tests the claim. Inflection requires data about what changed in usage after the launches; none is cited.

- **"110k / 117k weekly installs" for Frontend Design and Remotion** (Sub-question 2). Graded Medium in confidence.md but the sole source [3] is Firecrawl's blog. Firecrawl sells a skill-generator product — this is direct vendor-adjacent marketing. "Weekly installs" is also never defined: unique users? re-installs? install events across CLIs? The number is repeated three times in the report as if corroborated.

- **"80%+ activation reliability with strong descriptions vs 50% baseline"** (Sub-question 1 / Limitations). Single citation [10]. No benchmark methodology, no task mix, no sample size. Reliability numbers without a test suite are folklore. The report treats this as a design principle.

- **"84% permission-prompt reduction via sandboxing"** (Sub-question 4 / Recommendation). Single source [19] ("Get AI Perks"). A single marketing-flavored outlet with a specific metric is weaker than silence. Used twice in the report as if measured.

- **"Skills scale gracefully from inline-only to MCP-enhanced"** (TL;DR). Asserted, not demonstrated. The report lists Poudel's four categories but never shows the scaling claim fails gracefully — no cases of complexity where skills degrade, no latency/token curves across categories.

- **"SKILL.md is a portable cross-agent open standard"** (High-confidence key takeaway). Graded High, but three of four citations [1, 4, 6] trace back to Anthropic or aligned authors; [12] is a single community post. "Open standard" implies governance, versioning, and a spec body — agentskills.io is a domain, not a standards process. The report conflates a shared file convention with an open standard.

- **"Meta March 2026 incident"** (Sub-question 4). Confidence.md flags it Medium-single-source. The report still uses it as emotional proof ("at one of the world's best-resourced tech companies"). One blog post is not enough to anchor a "look, even Meta" argument.

## Selection bias assessment

Of 22 L2 sources, rough breakdown by independence:

- **Vendor / vendor-adjacent:** Anthropic docs + anthropics/skills [1, 2, 10], agentskills.io [4], Firecrawl blog [3], "Get AI Perks" [19], AIMaker [7], Cowork / ALM Corp launch posts [16, 17, 18] — roughly **8–10 of 22**, i.e. 36–45% of the pool either sells adjacent products or is publishing launch PR.
- **Independent practitioner posts:** Poudel [6], Unicodeveloper [12], Tawil [20], community taxonomies [5, 11, 21]. Useful but mostly single-author blogs without editorial review.
- **Security press with process:** Check Point Research citation for CVE-2025-59536 [15], Oasis Security for Claudy Day [15]. These are the strongest sources in the set.
- **Community aggregators:** awesome-claude-skills [3], ClaudePluginHub [22]. Indicate popularity, not quality.

**Perspectives under-represented:**
- No enterprise buyer who evaluated skills and chose MCP-only, or chose Cursor/Codex instead.
- No regulated-industry voice (finance, health) on skills-as-supply-chain.
- No skeptical security researcher arguing the marketplace model itself is the wrong abstraction.
- No non-Anthropic CLI vendor (Cursor, Gemini CLI) describing cross-agent reality vs. aspiration — the portability claim is asserted from one side only.
- No academic / benchmark source. Everything is blog-grade.

## Hidden assumptions

- Install counts equal adoption. They do not — a skill can be installed, auto-loaded on every request (paying token cost), and rarely fire.
- The marketplace is durable. No baseline is given from analogous ecosystems (VS Code extensions, Chrome Web Store) where marketplace quality decay, abandonment, and malware have all been problems.
- Progressive disclosure is free. Metadata is "only ~100 tokens per skill" is repeated without accounting for cache-invalidation cost, retrieval latency, or the combinatorial cost of many-skill workspaces.
- Cross-agent portability implies cross-agent equivalence. The report itself lists "cross-agent reliability drift" as an open question, then ignores it in the recommendation.
- The user is a solo practitioner. The recommendation reads as individual advice; enterprise trade-offs are bolted on in point 4.

## Missing considerations

- **Enterprise buyers who rejected skills.** No voice from a CISO or platform team that evaluated Cowork and stayed with plain MCP + internal tooling because of supply-chain concerns. Given the CVE evidence the report itself cites, this perspective is conspicuously absent.
- **Cost-benefit at scale.** What does the token baseline actually cost at 100 seats × 8 hours × N requests/day when 20 skills are loaded? The report mentions 1,000+ tokens/request but never annualizes.
- **Alternatives comparison.** Raw Claude + well-described MCP servers vs. skills is never compared head-to-head. Subagents vs. skills is described as a hierarchy but not as a choice.
- **Skill deprecation / versioning story.** SKILL.md has no version field in the report's description. What happens when a skill's `allowed-tools` contract changes under users?
- **Moderation of the public marketplace.** Flagged as an open question but not treated as the red flag it is — unmoderated marketplaces + supply-chain attack surface + documented CVE is an active, not deferred, risk.
- **Failure modes of activation.** Only under-triggering is discussed. Over-triggering (wrong skill fires, silently burns tokens, produces wrong output) is not in the report.

## Recommendation validity

For a solo practitioner, the five-point recommendation is defensible but under-qualified:

1. Role-based bundles — reasonable, follows from token-overhead logic.
2. Third-person descriptions — well-sourced advice.
3. One skill, one job — well-sourced.
4. Cowork + OpenTelemetry + private GitHub — reasonable for large orgs but assumes the reader is already committed to Claude Code as the standard; no "don't adopt" branch.
5. Layered defenses but accept prompt injection as unsolved — accurate but fatalistic; a real recommendation would quantify residual risk by task type.

**Where the recommendation does not apply:**
- Teams handling regulated data where any residual prompt-injection class is disqualifying — the report's own sources say the class is unfixable, but the recommendation does not say "don't put skills on the path of sensitive data."
- Small teams without platform engineering to run OpenTelemetry + gateway filtering + Lasso hook + sandboxing — the stack the recommendation implies is non-trivial.
- Orgs multi-homed across Cursor/Codex/Claude Code — cross-agent drift is acknowledged as unknown, yet recommendation implicitly assumes the portability claim holds in production.

## Questions the report doesn't answer but should

- What is the measured adoption curve before and after Mar 6, 2026 — does "inflection" survive data?
- How does skill reliability differ across Opus 4.6 vs 4.7 vs Sonnet vs Haiku? (Open question, but material to the recommendation.)
- What percentage of public-marketplace skills have been updated in the last 30 days? (Abandonment rate proxy.)
- How many reported incidents trace to a skill vs. a plain MCP config? The CVE evidence is conflated under "skills-as-supply-chain" but the root of CVE-2025-59536 is MCP config, not SKILL.md.
- What does a Cowork admin actually see in OpenTelemetry — tool-level traces, or aggregate counts? (Governance strength depends on this.)
- Is there a published license / IP posture for community skills? Running third-party SKILL.md under enterprise is a legal question the report skips.
- What is the empirical false-activation rate for skills with "slightly pushy" descriptions — i.e. does the 50→80% reliability gain cost over-triggering elsewhere?

**Bottom line:** The L2 is a tidy narrative synthesis with real citations but leans heavily on vendor-adjacent and single-author sources, treats install-count and reliability numbers as facts rather than evidence, and packages a "Q1 2026 inflection" frame the cited data cannot actually support. The security section is the strongest; the market/adoption claims are the weakest; the recommendation generalizes a solo practitioner's path into an org-level prescription without the matching evidence.
