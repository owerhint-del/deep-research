# Contradictions found

## C1: Can prompt injection be fixed?

**Source A** ([19] Get AI Perks): Sandboxing "safely reduces permission prompts by 84% while increasing safety" — implies mitigations work
**Source B** ([20] Tawil): "UK's top cyber agency: may never be fixed"; Meta March 2026 incident happened at "one of the world's best-resourced tech companies"

**Analysis:**
- [19] describes Claude Code's defensive mechanisms specifically
- [20] is about LLM agents broadly
- Both can be true: sandboxing + filtering reduce blast radius dramatically but cannot eliminate the class of attack

**Resolution:** Not a real contradiction — scope differs. Defensive controls (sandboxing, input filtering, permission prompts) reduce risk substantially; but prompt injection as a class remains unsolved at the model level. Accept both.

## C2: Public marketplace launch date

**Source A** ([7] AIMaker): March 6, 2026 — "Claude Marketplace launched"
**Source B** ([16] ALM Corp): February 24, 2026 — "plugin marketplaces" released for enterprise (Cowork)
**Source C** (Perplexity answer): Both dates — but distinguishes Cowork private (Feb 24) vs public Claude Marketplace (Mar 6)

**Analysis:** Two separate products launched ~10 days apart:
- **Feb 24:** Cowork private plugin marketplaces (enterprise admin-controlled)
- **Mar 6:** Claude Marketplace (public consumer-facing, community-ambassador program)

**Resolution:** Both dates correct for different products. Clarify in report.

## C3: Skill count scale

**Source A** ([12] Unicodeveloper): "1,234+ curated" (Antigravity library)
**Source B** ([12]): "thousands of community-contributed skills"
**Source C** ([3] Firecrawl): `awesome-claude-skills` has 8.7k stars (curated list); `anthropics/skills` is reference

**Analysis:** Different things conflated:
- 1,234+ = Antigravity's specific curated library
- "Thousands" = loose community-wide estimate
- 8.7k stars = popularity of a list, not count of skills

**Resolution:** Not contradictory, but L1 report should clarify "1,234+ in Antigravity's Awesome Skills library specifically."

## Summary

3 contradictions examined, all resolved via scope/context distinction. No unresolved conflicts between sources. Key theme: prompt injection is mitigable via layered defenses but not eliminable at the model level.
