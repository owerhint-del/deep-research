# OSINT Integration

`/osint-research` is a specialized skill in the deep-research plugin (v0.8.0+). It runs passive OSINT recon on a single entity and produces a hybrid findings/dossier/graph report. Unlike L0–L5 research skills (which are topic-focused), this skill is entity-focused.

**Spec:** `docs/superpowers/specs/2026-04-26-osint-research-design.md`

## Usage

```
/osint-research example.com                   # domain
/osint-research 8.8.8.8                       # IP
/osint-research user@example.com              # email
/osint-research "John Doe"                    # person (quoted)
/osint-research --company "Anthropic"         # company (explicit flag)
/osint-research github:anthropics             # github org/user
```

Output: `.firecrawl/osint/<slug>/osint-report.md` + supporting CSVs.

## Channels

Free, no auth:
- Whois / DNS (`dig`, `host`)
- crt.sh (Certificate Transparency)
- Wayback Machine
- Shodan InternetDB (free endpoint, no API key)
- GitHub code search (anonymous web; `gh` CLI improves rate limits)

Pay-per-use through existing project channels (already configured):
- Tavily (Google dorks, advanced operators)
- Firecrawl (page scrape after dork results)
- Exa (related entities, neural search)
- Perplexity (context enrichment)

Optional CLI tools (recommended; install if missing):
- `theHarvester` — `pipx install theHarvester`
- `subfinder` — `brew install subfinder`
- `amass` — `brew install amass`
- `dnstwist` — `pipx install dnstwist`
- `gh` — `brew install gh`

The skill works without optional tools but is shallower. Each report header shows which channels ran and what was skipped, with install tips.

## Security & Privacy

This skill follows a strict security policy enforced at helper level (not by Claude convention):

1. **No raw channel responses are ever written to disk.** Malformed responses → only structured metadata.
2. **Two-level domain blocklist.** Pastebin, dehashed, breachforums, doxbin, ddosecrets and similar dump sites are blocked both as outbound dork targets AND as inbound result hosts. Cannot be disabled. Extend with `OSINT_EXTRA_BLOCKLIST=host1,host2`.
3. **Inline secret redaction.** All ingested text passes through a regex-based redactor (AWS keys, GitHub PATs, JWTs, private keys, etc.). Detected secrets are recorded as `<first-4>...<last-4>`, never plaintext.
4. **No PII aggregation.** Public personal data is allowed under "Permissive" scope, but the skill never joins name + email + home address into a profile of a private individual.

See spec §13 for the full policy and reasoning.

## Limitations

- **Email-in-breach lookup:** out of scope. Free HIBP only checks password hashes; paid Breached Account API requires subscription which is excluded by design. Use `haveibeenpwned.com` UI externally for comprehensive breach checks.
- **Plaintext credential recovery:** out of scope by policy. The skill detects and locates leaked secrets but never records the value.
- **Person enrichment:** limited to LinkedIn dorks, GitHub commits, Wayback, Perplexity context. No paid people-search APIs.
- **Darkweb mentions:** out of scope.

## Disclaimer

Reports include a non-removable disclaimer. By using this skill, you agree to use the output responsibly and at your own risk. The author and tool are not responsible for misuse.
