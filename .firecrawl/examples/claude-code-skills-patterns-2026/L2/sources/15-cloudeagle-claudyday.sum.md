# Source 15: CloudEagle — How Secure Is Claude AI in 2026

**URL:** https://www.cloudeagle.ai/blogs/claude-security
**Type:** security-audit-blog
**Date:** 2026
**Quality:** A (cites specific CVEs)
**Relevant to:** subq4 (real CVE incidents)

## Key facts

- **Claudy Day vulnerability** (March 2026, disclosed by Oasis Security): chain of vulnerabilities in Claude.ai enabling **silent data exfiltration** via crafted Google search result. Prompt injection flaw patched; related fixes still in progress.
- **CVE-2025-59536** (February 2026, disclosed by Check Point Research, **CVSS 8.7**): critical flaw in Claude Code enabling **RCE and API key theft via malicious repository configs** (MCP configs). Patched.
- **GTG-1002** (2025): first documented AI-orchestrated cyberattack at scale, using Claude Code against **30 global organizations**
- Summary table confirms: "Yes, at infrastructure level" — SOC 2 Type II, AES-256, no training on enterprise data by default
- Biggest risks: prompt injection, Claude Code supply chain attacks, unsanctioned personal account usage

## Key quotes

> "In March 2026, Oasis Security disclosed Claudy Day, a chain of vulnerabilities in Claude.ai that enabled silent data exfiltration."
> "In February 2026, Check Point Research disclosed critical flaws in Claude Code, including CVE-2025-59536 (CVSS 8.7)."

## Notes

- **Concrete CVSS number** (8.7) — strong signal
- Three distinct incidents (Claudy Day, CVE-2025-59536, GTG-1002) anchor the 2026 security story
- **Supply chain** vector specifically relevant to skills: skills ARE supply chain (installed from external repos)
