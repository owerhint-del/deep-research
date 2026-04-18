[Sitemap](https://blog.stackademic.com/sitemap/sitemap.xml)

[Open in app](https://play.google.com/store/apps/details?id=com.medium.reader&referrer=utm_source%3DmobileNavBar&source=post_page---top_nav_layout_nav-----------------------------------------)

Sign up

[Sign in](https://medium.com/m/signin?operation=login&redirect=https%3A%2F%2Fblog.stackademic.com%2F84-of-developers-use-ai-coding-tools-in-april-2026-only-29-trust-what-they-ship-d0cb7ec9320a&source=post_page---top_nav_layout_nav-----------------------global_nav------------------)

[Medium Logo](https://medium.com/?source=post_page---top_nav_layout_nav-----------------------------------------)

Get app

[Write](https://medium.com/m/signin?operation=register&redirect=https%3A%2F%2Fmedium.com%2Fnew-story&source=---top_nav_layout_nav-----------------------new_post_topnav------------------)

[Search](https://medium.com/search?source=post_page---top_nav_layout_nav-----------------------------------------)

Sign up

[Sign in](https://medium.com/m/signin?operation=login&redirect=https%3A%2F%2Fblog.stackademic.com%2F84-of-developers-use-ai-coding-tools-in-april-2026-only-29-trust-what-they-ship-d0cb7ec9320a&source=post_page---top_nav_layout_nav-----------------------global_nav------------------)

![](https://miro.medium.com/v2/resize:fill:64:64/1*dmbNkD5D-u45r44go_cf0g.png)

[**Stackademic**](https://blog.stackademic.com/?source=post_page---publication_nav-d1baaa8417a4-d0cb7ec9320a---------------------------------------)

·

Follow publication

[![Stackademic](https://miro.medium.com/v2/resize:fill:76:76/1*U-kjsW7IZUobnoy1gAp1UQ.png)](https://blog.stackademic.com/?source=post_page---post_publication_sidebar-d1baaa8417a4-d0cb7ec9320a---------------------------------------)

Stackademic is a learning hub for programmers, devs, coders, and engineers. Our goal is to democratize free coding education for the world.

Follow publication

# 84% of Developers Use AI Coding Tools in April 2026 — Only 29% Trust What They Ship

## I’ve run production at 400k RPS across twelve companies. Everyone’s vibing with Cursor, Claude Code, and the new agent stacks. The gap between “it works” and “it survives Friday night” is wider than ever. Here’s the exact reality check I force on every team.

[![Clean Code Journal](https://miro.medium.com/v2/resize:fill:64:64/1*Or-QEM8ympJWg80O5S7tpA.png)](https://medium.com/@tercanyldz?source=post_page---byline--d0cb7ec9320a---------------------------------------)

[Clean Code Journal](https://medium.com/@tercanyldz?source=post_page---byline--d0cb7ec9320a---------------------------------------)

Follow

5 min read

·

Apr 6, 2026

19

[Listen](https://medium.com/m/signin?actionUrl=https%3A%2F%2Fmedium.com%2Fplans%3Fdimension%3Dpost_audio_button%26postId%3Dd0cb7ec9320a&operation=register&redirect=https%3A%2F%2Fblog.stackademic.com%2F84-of-developers-use-ai-coding-tools-in-april-2026-only-29-trust-what-they-ship-d0cb7ec9320a&source=---header_actions--d0cb7ec9320a---------------------post_audio_button------------------)

Share

Press enter or click to view image in full size

![](https://miro.medium.com/v2/resize:fit:700/1*ey73FH9zA2cI6RhhmlNkVA.png)

Look, I’ve been on the receiving end of pager storms for eight years. When the latest surveys dropped in April 2026 showing 84% of developers now use AI coding tools daily but only 29% actually trust the output in production, I wasn’t surprised. I’ve lived the gap.

Agents generate code faster than any junior I’ve ever mentored. They spit out clean endpoints, decent tests, and even reasonable architectures. Then production traffic hits and the same old demons appear — just faster and with more confidence.

I let the full agent stack loose on a real checkout service last quarter. Velocity felt magical for three days. The Monday morning incident cost real money. The agents didn’t hallucinate syntax. They hallucinated operational safety.

Here’s what the numbers hide and the one mindset shift that still separates the teams that ship reliably from the ones that create expensive postmortems.

## The Hype vs. The Pager in April 2026

Everyone talks about vibe coding, agentic workflows, and “full-cycle engineering” where you describe the feature and the agents handle planning, coding, testing, and deployment.

Reality on my clusters:

- 84% adoption: true. Cursor and Claude Code are in every IDE.
- 29% trust: also true. Most teams accept the PR, run basic tests, and pray.

The dangerous middle is growing. Developers generate more code than ever. They review less. The subtle bugs — cache stampedes, missing covering indexes, optimistic connection pools — slip through because the agent sounded confident and the tests passed in the happy path.

I’ve seen this movie before with Docker, Kubernetes, and Terraform. New abstraction layer. Same failure categories. Faster cycle time.

## The Five Patterns I Now Hunt in Every Agent PR

After the last expensive lesson, I added a mandatory “agent audit” step to every PR that touches AI-generated code. These five checks catch 80% of the problems before they reach canary.

1. **Cache & Invalidation** Agents love simple SET/DEL patterns. I force: “Show me the exact lock mechanism and what happens on stampede.” If it can’t simulate the flash-sale case with numbers, I rewrite.
2. **Database Queries** SELECT \* still sneaks in. No covering indexes. Functions on indexed columns. I require the agent to run EXPLAIN ANALYZE on the hot paths and explain the output. Most can’t without me feeding the command.
3. **Resource & Pool Assumptions** Agents default to “reasonable” limits based on docs. I demand measured kubectl top numbers from load tests and the exact PgBouncer config. No exceptions.
4. **Failure Mode Coverage** “What’s the 3 a.m. detection query for this?” is the killer question. Strong agent output includes the copy-paste SQL or log line I’d actually use when paged. Weak output gives vague “add monitoring.”
5. **Blast Radius** Anything touching money, user data, or schema changes gets human review. Agents suggest. Humans own.

These aren’t new. They’re the same scars every ops engineer carries. AI just makes the scars appear quicker.

## The Mindset That Still Wins

In April 2026 the highest-leverage skill isn’t prompting better or choosing the shiniest agent framework. It’s treating every agent output like code from a very fast, slightly overconfident intern who has never been on-call.

You still own the pager.

I now run a simple weekly exercise with the team:

- Pick one agent-generated module from last week.
- Run it through the five checks above.
- Measure time to “production ready” including fixes.
- Compare against doing it the old way.

The gap narrows when you do this religiously. Teams that skip it create the next $80K incident.

## Get Clean Code Journal’s stories in your inbox

Join Medium for free to get updates from this writer.

Subscribe

Subscribe

Remember me for faster sign in

The trends everyone is hyping — vibe engineering, autonomous agents, low-code democratization — are real. They accelerate the happy path dramatically. They do not replace the operational judgment that keeps the lights on when traffic spikes or a dependency quietly breaks.

## My Current April 2026 Workflow

1. Write the spec with explicit success metrics, non-goals, and past failure modes from similar services.
2. Feed to Cursor/Claude with narrow scope and explicit guardrails (no direct cache mutate, no schema changes without review, etc.).
3. Run the five-check audit before any human review.
4. Chaos test in canary with synthetic load that matches prod patterns.
5. Human gate on anything with blast radius.

Net result: velocity still 1.6–2.2x on boilerplate. Incident rate from agent code: near zero when we enforce the checks. Pager load: noticeably quieter.

The agents are tools. Powerful ones. But they optimize for passing the tests you gave them, not for surviving the production environment you actually run.

## The Incidents That Keep Costing Money

Even with better tools, the same categories bite:

- Cache stampedes from optimistic invalidation
- Slow queries from missing indexes or SELECT \*
- Connection pool exhaustion
- Subtle races or migration issues under load

I keep the raw collection of 30 real production failures — exact code/config that caused them, the detection commands/queries I used at 3 a.m., the fix, and the prevention checklist that now gates every agent change.

→ [**30 Production Incidents That Cost $10K+**](https://yusufseyitoglu.gumroad.com/l/production-incidents) (free)

When the database part gets touched (and agents love touching it), the incident playbook with copy-paste ready queries for slow queries, locks, VACUUM, connection management, and replication lag on both PostgreSQL and MySQL has saved more nights than I can count:

→ [**Your Database Is Bleeding Money. The Incident Playbook.**](https://yusufseyitoglu.gumroad.com/l/db-incident-playbook) (free)

And the SQL performance cheatsheet that shows you how to actually read EXPLAIN ANALYZE, design composite/covering indexes, and kill the 10 most common anti-patterns before they hit prod:

→ [**SQL Performance Cheatsheet — Queries That Scale**](https://yusufseyitoglu.gumroad.com/l/sql-performance-cheatsheet) (free)

## Do This Before Your Next Agent Session

Take the last piece of AI-generated code you merged. Run it through the five checks above — especially the “show me the 3 a.m. detection query” one.

If it survives, great. If it feels vague or overly optimistic, you just found tomorrow’s incident.

84% of developers use the tools. The 29% who trust them enough to ship without heavy review are the ones creating the expensive stories we read on HN.

Be in the group that uses the tools aggressively but reviews with the paranoia of someone who’s been paged too many times.

The agents will keep getting faster. Production will keep being production.

You write it. You still own what runs when the traffic hits and the happy path dies.

Run the checks. Build the taste. Sleep better.

Froquiz has 10,000+ questions across SQL, Docker, Git, AWS, JavaScript, Java, Python, React, Microservices and more — plus a Senior Dev Challenge with real scenario-based questions, not syntax drills. → [**Froquiz**](https://froquiz.com/)

[Coding](https://medium.com/tag/coding?source=post_page-----d0cb7ec9320a---------------------------------------)

[Programming](https://medium.com/tag/programming?source=post_page-----d0cb7ec9320a---------------------------------------)

[Web Development](https://medium.com/tag/web-development?source=post_page-----d0cb7ec9320a---------------------------------------)

[Software Development](https://medium.com/tag/software-development?source=post_page-----d0cb7ec9320a---------------------------------------)

[JavaScript](https://medium.com/tag/javascript?source=post_page-----d0cb7ec9320a---------------------------------------)

[![Stackademic](https://miro.medium.com/v2/resize:fill:96:96/1*U-kjsW7IZUobnoy1gAp1UQ.png)](https://blog.stackademic.com/?source=post_page---post_publication_info--d0cb7ec9320a---------------------------------------)

[![Stackademic](https://miro.medium.com/v2/resize:fill:128:128/1*U-kjsW7IZUobnoy1gAp1UQ.png)](https://blog.stackademic.com/?source=post_page---post_publication_info--d0cb7ec9320a---------------------------------------)

Follow

[**Published in Stackademic**](https://blog.stackademic.com/?source=post_page---post_publication_info--d0cb7ec9320a---------------------------------------)

[81K followers](https://blog.stackademic.com/followers?source=post_page---post_publication_info--d0cb7ec9320a---------------------------------------)

· [Last published 16 hours ago](https://blog.stackademic.com/10-python-tips-that-make-your-code-easier-to-read-751285560ae2?source=post_page---post_publication_info--d0cb7ec9320a---------------------------------------)

Stackademic is a learning hub for programmers, devs, coders, and engineers. Our goal is to democratize free coding education for the world.

Follow

[![Clean Code Journal](https://miro.medium.com/v2/resize:fill:96:96/1*Or-QEM8ympJWg80O5S7tpA.png)](https://medium.com/@tercanyldz?source=post_page---post_author_info--d0cb7ec9320a---------------------------------------)

[![Clean Code Journal](https://miro.medium.com/v2/resize:fill:128:128/1*Or-QEM8ympJWg80O5S7tpA.png)](https://medium.com/@tercanyldz?source=post_page---post_author_info--d0cb7ec9320a---------------------------------------)

Follow

[**Written by Clean Code Journal**](https://medium.com/@tercanyldz?source=post_page---post_author_info--d0cb7ec9320a---------------------------------------)

[18 followers](https://medium.com/@tercanyldz/followers?source=post_page---post_author_info--d0cb7ec9320a---------------------------------------)

· [103 following](https://medium.com/@tercanyldz/following?source=post_page---post_author_info--d0cb7ec9320a---------------------------------------)

Write cleaner, smarter, better code.

Follow

## No responses yet

![](https://miro.medium.com/v2/resize:fill:32:32/1*dmbNkD5D-u45r44go_cf0g.png)

Write a response

[What are your thoughts?](https://medium.com/m/signin?operation=register&redirect=https%3A%2F%2Fblog.stackademic.com%2F84-of-developers-use-ai-coding-tools-in-april-2026-only-29-trust-what-they-ship-d0cb7ec9320a&source=---post_responses--d0cb7ec9320a---------------------respond_sidebar------------------)

Cancel

Respond

## More from Clean Code Journal and Stackademic

![We Have 30 AI Agents Running in Production — 76% of Similar Projects Failed.](https://miro.medium.com/v2/resize:fit:679/format:webp/1*DKvVL33A0YFsKw3tUh3fdQ.png)

[![Artificial Intelligence in Plain English](https://miro.medium.com/v2/resize:fill:20:20/1*9zAmnK08gUCmZX7q0McVKw@2x.png)](https://ai.plainenglish.io/?source=post_page---author_recirc--d0cb7ec9320a----0---------------------5ed42b2f_40d6_4879_9800_d2c443babf7c--------------)

In

[Artificial Intelligence in Plain English](https://ai.plainenglish.io/?source=post_page---author_recirc--d0cb7ec9320a----0---------------------5ed42b2f_40d6_4879_9800_d2c443babf7c--------------)

by

[Clean Code Journal](https://medium.com/@tercanyldz?source=post_page---author_recirc--d0cb7ec9320a----0---------------------5ed42b2f_40d6_4879_9800_d2c443babf7c--------------)

Apr 7

[A clap icon20](https://ai.plainenglish.io/we-have-30-ai-agents-running-in-production-76-of-similar-projects-failed-04283928051e?source=post_page---author_recirc--d0cb7ec9320a----0---------------------5ed42b2f_40d6_4879_9800_d2c443babf7c--------------)

![Your AI Is Useless Without These 8 MCP Servers — Most Developers Have Never Heard of Them](https://miro.medium.com/v2/resize:fit:679/format:webp/1*LiLr1Hjh5B3p6b9Jz4mH4w.png)

[![Stackademic](https://miro.medium.com/v2/resize:fill:20:20/1*U-kjsW7IZUobnoy1gAp1UQ.png)](https://blog.stackademic.com/?source=post_page---author_recirc--d0cb7ec9320a----1---------------------5ed42b2f_40d6_4879_9800_d2c443babf7c--------------)

In

[Stackademic](https://blog.stackademic.com/?source=post_page---author_recirc--d0cb7ec9320a----1---------------------5ed42b2f_40d6_4879_9800_d2c443babf7c--------------)

by

[Usman Writes](https://pixicstudio.medium.com/?source=post_page---author_recirc--d0cb7ec9320a----1---------------------5ed42b2f_40d6_4879_9800_d2c443babf7c--------------)

Feb 26

[A clap icon1.4K\\
\\
A response icon31](https://blog.stackademic.com/best-mcp-servers-for-developers-149e8976641c?source=post_page---author_recirc--d0cb7ec9320a----1---------------------5ed42b2f_40d6_4879_9800_d2c443babf7c--------------)

![The One Color Decision That Makes a UI Look Expensive](https://miro.medium.com/v2/resize:fit:679/format:webp/1*q70a70O_r44DK1kSj5IBWA.png)

[![Stackademic](https://miro.medium.com/v2/resize:fill:20:20/1*U-kjsW7IZUobnoy1gAp1UQ.png)](https://blog.stackademic.com/?source=post_page---author_recirc--d0cb7ec9320a----2---------------------5ed42b2f_40d6_4879_9800_d2c443babf7c--------------)

In

[Stackademic](https://blog.stackademic.com/?source=post_page---author_recirc--d0cb7ec9320a----2---------------------5ed42b2f_40d6_4879_9800_d2c443babf7c--------------)

by

[Usman Writes](https://pixicstudio.medium.com/?source=post_page---author_recirc--d0cb7ec9320a----2---------------------5ed42b2f_40d6_4879_9800_d2c443babf7c--------------)

Mar 9

[A clap icon1.8K\\
\\
A response icon26](https://blog.stackademic.com/color-decision-premium-ui-design-d6890efe11ba?source=post_page---author_recirc--d0cb7ec9320a----2---------------------5ed42b2f_40d6_4879_9800_d2c443babf7c--------------)

![Linux 7.0 Just Halved PostgreSQL Throughput on My AWS Clusters — Here’s the Fix I Pushed in 38…](https://miro.medium.com/v2/resize:fit:679/format:webp/1*Ym-08wqjP-VMxYimWQTAyQ.png)

[![AWS in Plain English](https://miro.medium.com/v2/resize:fill:20:20/1*6EeD87OMwKk-u3ncwAOhog.png)](https://aws.plainenglish.io/?source=post_page---author_recirc--d0cb7ec9320a----3---------------------5ed42b2f_40d6_4879_9800_d2c443babf7c--------------)

In

[AWS in Plain English](https://aws.plainenglish.io/?source=post_page---author_recirc--d0cb7ec9320a----3---------------------5ed42b2f_40d6_4879_9800_d2c443babf7c--------------)

by

[Clean Code Journal](https://medium.com/@tercanyldz?source=post_page---author_recirc--d0cb7ec9320a----3---------------------5ed42b2f_40d6_4879_9800_d2c443babf7c--------------)

Apr 5

[See all from Clean Code Journal](https://medium.com/@tercanyldz?source=post_page---author_recirc--d0cb7ec9320a---------------------------------------)

[See all from Stackademic](https://blog.stackademic.com/?source=post_page---author_recirc--d0cb7ec9320a---------------------------------------)

## Recommended from Medium

![I Cut Claude Code’s Output Tokens by 75%. Why Did Nobody Tell Me?](https://miro.medium.com/v2/resize:fit:679/format:webp/1*JMSxwQX3sJpPkXz998-5bA.png)

[![Vibe Coding](https://miro.medium.com/v2/resize:fill:20:20/1*nD0mORiSRPKPztpAByfNdw.png)](https://medium.com/vibe-coding?source=post_page---read_next_recirc--d0cb7ec9320a----0---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

In

[Vibe Coding](https://medium.com/vibe-coding?source=post_page---read_next_recirc--d0cb7ec9320a----0---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

by

[Alex Dunlop](https://medium.com/@alexjamesdunlop?source=post_page---read_next_recirc--d0cb7ec9320a----0---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

Apr 11

[A clap icon1K\\
\\
A response icon12](https://medium.com/vibe-coding/i-cut-claude-codes-output-tokens-by-75-why-did-nobody-tell-me-3275138852e2?source=post_page---read_next_recirc--d0cb7ec9320a----0---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

![Vibe Coding is Over illustration of three ai generated landing pages with the words IT’S OVER written at the top in large text](https://miro.medium.com/v2/resize:fit:679/format:webp/1*1OGKfKCooEZbKCSoSXXY8g.png)

[![Michal Malewicz](https://miro.medium.com/v2/resize:fill:20:20/1*149zXrb2FXvS_mctL4NKSg.png)](https://michalmalewicz.medium.com/?source=post_page---read_next_recirc--d0cb7ec9320a----1---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

[Michal Malewicz](https://michalmalewicz.medium.com/?source=post_page---read_next_recirc--d0cb7ec9320a----1---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

Mar 24

[A clap icon6.2K\\
\\
A response icon239](https://michalmalewicz.medium.com/vibe-coding-is-over-5a84da799e0d?source=post_page---read_next_recirc--d0cb7ec9320a----1---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

![If You Understand These 5 AI Terms, You’re Ahead of 90% of People](https://miro.medium.com/v2/resize:fit:679/format:webp/1*qbVrf-wO9PYtthAj6E4RYQ.png)

[![Towards AI](https://miro.medium.com/v2/resize:fill:20:20/1*JyIThO-cLjlChQLb6kSlVQ.png)](https://pub.towardsai.net/?source=post_page---read_next_recirc--d0cb7ec9320a----0---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

In

[Towards AI](https://pub.towardsai.net/?source=post_page---read_next_recirc--d0cb7ec9320a----0---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

by

[Shreyas Naphad](https://medium.com/@shreyasnaphad?source=post_page---read_next_recirc--d0cb7ec9320a----0---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

Mar 29

[A clap icon11.4K\\
\\
A response icon229](https://pub.towardsai.net/if-you-understand-these-5-ai-terms-youre-ahead-of-90-of-people-c7622d353319?source=post_page---read_next_recirc--d0cb7ec9320a----0---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

![I used Karpathy’s LLM Wiki to build a knowledge base that maintains itself with AI](https://miro.medium.com/v2/resize:fit:679/format:webp/1*vxRXppphspYQRlf3vgTy9g.png)

[![Balu Kosuri](https://miro.medium.com/v2/resize:fill:20:20/1*8PS5vEDRlh41uAjCPGvUQg.jpeg)](https://medium.com/@k.balu124?source=post_page---read_next_recirc--d0cb7ec9320a----1---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

[Balu Kosuri](https://medium.com/@k.balu124?source=post_page---read_next_recirc--d0cb7ec9320a----1---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

Apr 7

[A clap icon947\\
\\
A response icon13](https://medium.com/@k.balu124/i-used-karpathys-llm-wiki-to-build-a-knowledge-base-that-maintains-itself-with-ai-df968e4f5ea0?source=post_page---read_next_recirc--d0cb7ec9320a----1---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

![MemPalace: The Viral AI Memory System That Got 22K Stars in 48 Hours (An Honest Look and Setup…](https://miro.medium.com/v2/resize:fit:679/format:webp/1*UWFl_-VsZYvZbAZQdJafpA.png)

[![Kristopher Dunham](https://miro.medium.com/v2/resize:fill:20:20/1*PsZLmtO9Go4TeJeVRy5FSQ.jpeg)](https://medium.com/@creativeaininja?source=post_page---read_next_recirc--d0cb7ec9320a----2---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

[Kristopher Dunham](https://medium.com/@creativeaininja?source=post_page---read_next_recirc--d0cb7ec9320a----2---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

Apr 8

[A clap icon728\\
\\
A response icon9](https://medium.com/@creativeaininja/mempalace-the-viral-ai-memory-system-that-got-22k-stars-in-48-hours-an-honest-look-and-setup-26c234b0a27b?source=post_page---read_next_recirc--d0cb7ec9320a----2---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

![I Tried Gemma 4 On Claude Code (And Found New FREE Google Coding Beast)](https://miro.medium.com/v2/resize:fit:679/format:webp/1*kLyuUq1qxXrLhFE3Gfhbxw.png)

[![Joe Njenga](https://miro.medium.com/v2/resize:fill:20:20/1*0Hoc7r7_ybnOvk1t8yR3_A.jpeg)](https://medium.com/@joe.njenga?source=post_page---read_next_recirc--d0cb7ec9320a----3---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

[Joe Njenga](https://medium.com/@joe.njenga?source=post_page---read_next_recirc--d0cb7ec9320a----3---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

Apr 7

[A clap icon602\\
\\
A response icon21](https://medium.com/@joe.njenga/i-tried-gemma-4-on-claude-code-and-found-new-free-google-coding-beast-6d0995ba8645?source=post_page---read_next_recirc--d0cb7ec9320a----3---------------------1c052a9f_eef6_4e5b_9e31_0ef904edb639--------------)

[See more recommendations](https://medium.com/?source=post_page---read_next_recirc--d0cb7ec9320a---------------------------------------)

[Help](https://help.medium.com/hc/en-us?source=post_page-----d0cb7ec9320a---------------------------------------)

[Status](https://status.medium.com/?source=post_page-----d0cb7ec9320a---------------------------------------)

[About](https://medium.com/about?autoplay=1&source=post_page-----d0cb7ec9320a---------------------------------------)

[Careers](https://medium.com/jobs-at-medium/work-at-medium-959d1a85284e?source=post_page-----d0cb7ec9320a---------------------------------------)

[Press](mailto:pressinquiries@medium.com)

[Blog](https://blog.medium.com/?source=post_page-----d0cb7ec9320a---------------------------------------)

[Privacy](https://policy.medium.com/medium-privacy-policy-f03bf92035c9?source=post_page-----d0cb7ec9320a---------------------------------------)

[Rules](https://policy.medium.com/medium-rules-30e5502c4eb4?source=post_page-----d0cb7ec9320a---------------------------------------)

[Terms](https://policy.medium.com/medium-terms-of-service-9db0094a1e0f?source=post_page-----d0cb7ec9320a---------------------------------------)

[Text to speech](https://speechify.com/medium?source=post_page-----d0cb7ec9320a---------------------------------------)

reCAPTCHA

Recaptcha requires verification.

protected by **reCAPTCHA**