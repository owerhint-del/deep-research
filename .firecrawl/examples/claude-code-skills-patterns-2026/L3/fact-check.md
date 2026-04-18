# Fact-check Report — Top 5 Critical Claims

## Claim 1: "SKILL.md is a cross-agent open standard (agentskills.io Dec 2025)"

**Sources in L2:** [1, 4, 6, 12]

**Verification:**
- ✓ Confirmed: [1] Anthropic docs describe SKILL.md format
- ✓ Confirmed: [4, 6, 12] three independent authors describe same file format
- ? **Critic caveat (important):** "Open standard" implies governance, versioning, spec body. Evidence shows: shared file convention documented by Anthropic at agentskills.io. Three of four citations trace to Anthropic-adjacent authors.

**Verdict:** **CONFIRMED as shared file convention** (strong); **DISPUTED as formal "open standard"** (no spec body, no governance, no independent implementations beyond Anthropic-adjacent platforms). Downgrade language in final report from "open standard" to "cross-platform file convention."

## Claim 2: "Remotion 117k, Frontend Design 110k weekly installs"

**Sources in L2:** [3] Firecrawl blog

**Verification:**
- ✗ **Single source** — Firecrawl's own blog, which has commercial interest in the skills ecosystem
- Independent corroboration attempts: L3 neutral sources don't cite these specific numbers
- [12] corroborates Frontend Design's ecosystem prominence but not the weekly install number

**Verdict:** **UNVERIFIED** — plausible direction but not independently benchmarked. Flag in report as "Firecrawl-reported" rather than "confirmed."

## Claim 3: "CVE-2025-59536 CVSS 8.7 in Claude Code"

**Sources in L2:** [15] CloudEagle

**Verification:**
- ✓ Confirmed via CloudEagle citing Check Point Research directly
- ✓ Critic flagged important nuance: **CVE is in MCP config loading, not SKILL.md itself** — report shouldn't conflate "skills" and "MCP supply chain"

**Verdict:** **CONFIRMED with correction** — the CVE is Claude Code (MCP-related), not skill-specific. Report should distinguish "skill supply chain" from "MCP config supply chain" — related but not identical attack surfaces.

## Claim 4: "Sandboxing reduces permission prompts by 84%"

**Sources in L2:** [19] Get AI Perks

**Verification:**
- ✗ **Single source** — marketing-flavored outlet, no independent benchmark cited
- Direction plausible (sandboxing does reduce prompts) but specific quant hard to verify
- L3 neutral sources don't touch this

**Verdict:** **UNVERIFIED** — treat as vendor/marketing claim until independent data available. Soften language.

## Claim 5: "Q1 2026 = marketplace inflection"

**Framing claim in L2 executive summary**

**Verification:**
- ✓ Confirmed: timeline facts are right (Feb 24 Cowork private, Mar 6 public marketplace) per [7, 16, 17]
- ✗ **"Inflection" is narrative, not empirical** — no before/after adoption curve, no retention data, no evidence that marketplaces changed actual outcomes
- L3 sources [26] and [27] suggest growth is marketing-driven, not organic

**Verdict:** **DISPUTED as framing** — timeline correct but "inflection" overclaims causality. Reframe in final report as "Q1 2026 = major product/distribution releases" without claiming they drove a measurable inflection in adoption or usage.

---

## Summary

- **CONFIRMED:** 1 claim (CVE exists, with MCP-scope correction)
- **CONFIRMED with correction:** 1 (CVE-2025-59536 — scope is MCP config not skills)
- **DISPUTED:** 2 claims (open-standard framing, marketplace-inflection framing)
- **UNVERIFIED:** 2 claims (install numbers, 84% sandbox reduction)

**Key correction for final report:**
- **Downgrade "open standard" → "cross-platform file convention"**
- **Separate "skill supply chain" from "MCP config supply chain"** — CVE-2025-59536 was the latter
- **Add the 84%/29% trust-adoption paradox** (from L3 [23]) as headline neutral signal — previously absent
