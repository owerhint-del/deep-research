[Skip to content](https://almcorp.com/blog/claude-cowork-plugins-enterprise-guide/#content)

![claude-cowork-plugins-for-enterprise](https://almcorp.com/wp-content/uploads/2026/02/claude-cowork-plugins-for-enterprise.webp)

- February 25, 2026
- 11 mins read
- [AI](https://almcorp.com/blog/category/ai/)

# Claude Cowork Plugins for Enterprise: Private Marketplaces, 10+ New Connectors, and Department-Specific AI Agents — The Complete 2026 Guide

By

ALM Corp

## What Actually Changed on February 24, 2026

On February 24, 2026, Anthropic published what may be its most consequential enterprise product update to date. The company announced a sweeping set of upgrades to [Claude Cowork](https://claude.com/blog/cowork-plugins-across-enterprise) — its AI productivity platform for knowledge workers — that includes private plugin marketplaces, ten new department-specific plugins, twelve new MCP connectors, cross-app workflows between Excel and PowerPoint, and a new admin control system called “Customize.”

The update was timed alongside a virtual enterprise briefing where Anthropic’s head of Americas, Kate Jensen, opened with a frank acknowledgment: _“2025 was meant to be the year agents transformed the enterprise, but the hype turned out to be mostly premature. It wasn’t a failure of effort. It was a failure of approach.”_ [Source](https://venturebeat.com/orchestration/anthropic-says-claude-code-transformed-programming-now-claude-cowork-is)

That admission set the tone for a product rollout designed to address the structural problems that caused enterprise AI pilots to stall throughout 2025. Nearly two-thirds of organizations had yet to scale AI across the enterprise, according to research from McKinsey and Grandview Research — not because AI lacked capability, but because it wasn’t fitting into how real teams actually work. [Source](https://www.forbes.com/sites/ronschmelzer/2026/02/25/anthropic-leans-into-enterprise-ai-agents-that-fit-business-workflow/)

The February 24 Cowork update addresses three specific friction points that enterprises consistently reported: difficulty deploying Claude to non-technical staff, insufficient control over what plugins employees can access, and a lack of tools tailored to specific job functions. Whether the updates resolve those complaints fully is something enterprises will measure over time. What can be assessed now is what was actually shipped, how each piece works, and what it means for teams across finance, HR, engineering, design, operations, and legal.

## What Is Claude Cowork? A Working Definition

Before examining the specifics of the February 2026 update, a clear definition of what Cowork actually is and how it fits within Anthropic’s product line matters.

Cowork is Anthropic’s enterprise-focused AI productivity platform. It sits between Claude.ai — the general-purpose consumer chatbot — and Claude Code, which targets software developers. Cowork is designed for knowledge workers who need Claude to execute multi-step tasks involving files, data, and external tools, without requiring any programming knowledge. As Anthropic’s product officer Matt Piccolella put it: _“We believe that the future of work means everybody having their own custom agent.”_ [Source](https://techcrunch.com/2026/02/24/anthropic-launches-new-push-for-enterprise-agents-with-plugins-for-finance-engineering-and-design/)

The platform uses the [Model Context Protocol (MCP)](https://modelcontextprotocol.io/docs/getting-started/intro) — an open standard Anthropic introduced in late 2024 — to connect Claude to external data sources and software tools. Those connections, called **connectors**, allow Claude to pull information from systems like Google Drive, Salesforce, or FactSet and act on it within a workflow. **Plugins** are pre-configured bundles of skills, commands, and connectors that shape Claude’s behavior for a specific department or job function.

Cowork was first released in research preview on January 30, 2026. As of February 24, Anthropic described it as a “true enterprise-grade product” with the admin controls, governance features, and organizational customization that corporate IT departments require. [Source](https://www.cnbc.com/2026/02/24/anthropic-claude-cowork-office-worker.html)

The financial context around this launch is relevant. Enterprise contracts account for roughly 80% of Anthropic’s business. The company closed a $30 billion funding round in February 2026 at a $380 billion valuation. That scale signals where Anthropic’s product investment is concentrated, and the February 24 announcements reflect exactly that priority. [Source](https://www.cnbc.com/2026/02/24/anthropic-claude-cowork-office-worker.html)

## Private Plugin Marketplaces: How the Architecture Works

The most structurally significant part of the February 24 announcement is the ability for enterprise admins to build **private plugin marketplaces**. This changes the fundamental dynamic of how AI gets deployed inside a company.

Previously, enterprises using Claude had access to Anthropic’s public plugins and connectors, but no systematic way to distribute customized, company-specific agents to employees at scale. With private marketplaces, admins can now create a curated catalog of plugins tailored to their organization’s workflows, terminology, and data sources — and then control which employees see and can use each one.

**How the build process works:** Admins access a new unified menu called “Customize,” which consolidates plugins, skills, and connectors into a single management interface. From there, they can either start from a starter template or build from scratch. During setup, Claude guides the admin through a conversational question-and-answer process to define what skills the plugin should have, what slash commands it should respond to, and which connectors it needs. The resulting plugin is a portable file system that the organization owns outright.

Admins can also source plugins from **private GitHub repositories** — a feature currently in private beta. This means a company’s internal development team can write and version plugins in a private repo and publish them to the internal marketplace without routing code through Anthropic’s infrastructure. That distinction matters significantly for IP-sensitive organizations and those in regulated industries where data residency and code governance are formal compliance requirements.

On the distribution side, admins now have **per-user provisioning** and **auto-install** capabilities. They can grant plugin access to specific users, push plugins automatically to designated teams, and control which employees can see which plugins in the marketplace. The workflow looks and behaves like the internal software distribution systems that IT departments already manage — a deliberate design decision intended to reduce the organizational friction of AI adoption.

Scott White, Anthropic’s head of product for Claude Enterprise, described the philosophy plainly: _“We’ve heard loud and clear from enterprises: you want Claude to work the way that your company works — not just Claude for legal, but Cowork for legal at your company. That’s exactly what today’s launches deliver.”_ [Source](https://venturebeat.com/orchestration/anthropic-says-claude-code-transformed-programming-now-claude-cowork-is)

## The “Customize” Menu and Updated Admin Controls

Prior to this update, admins managing Claude for their organization had to navigate separate interfaces to handle plugins, connectors, and skills. The new **“Customize” menu** consolidates everything.

The connector management overhaul is worth specific attention. A connector is the link between Claude and an external tool — for example, the Google Calendar connector that allows Claude to read and write calendar events. The updated interface lets admins see all available connectors, authorize them at the organization level, and attach them to specific plugins in a single flow. Previously, that process required multiple steps across different settings panels.

For users, **slash commands** have been updated to launch with structured forms rather than open-ended text prompts. When an employee types `/generate-report` or `/dashboard`, they now see a form that prompts them for required inputs — date range, data source, output format, and so on. This makes running a workflow feel more like filling out a standard business form than prompting an AI from scratch, which meaningfully reduces the learning curve for non-technical staff.

Cowork also now supports **company branding** throughout the interface. Organizations can configure a home screen that reflects their own visual identity, including a redesigned home experience that surfaces the plugins and connectors most relevant to their teams.

Finally, **OpenTelemetry support** has been added, giving admins the ability to track usage, costs, and tool activity across their teams. OpenTelemetry is a widely adopted observability standard used across enterprise software, meaning this data can feed into existing monitoring dashboards and security information and event management (SIEM) systems without custom integration work. [Source](https://claude.com/blog/cowork-plugins-across-enterprise)

## Complete List of New MCP Connectors (February 2026)

Connectors are the integrations that bring live external data into Claude’s context. The February 24 update added twelve new connectors across productivity, sales, legal, finance, and data categories. Here is each one and what it enables:

**[Google Calendar](https://claude.com/connectors/google-calendar)** — Allows Claude to read and write calendar events, schedule meetings, and check availability within Google Workspace. Useful for any workflow that involves scheduling or time-based planning.

**[Google Drive](https://claude.com/connectors/google-drive)** — Provides Claude with access to documents, spreadsheets, presentations, and files stored in Google Drive, enabling document analysis and content generation grounded in real company materials.

**[Gmail](https://claude.com/connectors/gmail)** — Allows Claude to search, read, draft, and reference email threads, enabling inbox-integrated workflows for communication, follow-ups, and content extraction.

**[DocuSign](https://claude.com/connectors/docusign)** — Connects Claude to DocuSign-managed contracts and signature workflows. Particularly useful for legal, HR, and procurement teams processing high volumes of agreements.

**[Apollo](https://claude.com/connectors/apollo)** — Connects Claude to Apollo’s B2B sales intelligence platform, enabling it to pull company data, contact information, and prospect insights directly into sales workflows.

**[Clay](https://claude.com/connectors/clay)** — Integrates Claude with Clay’s data enrichment and outreach automation platform, supporting go-to-market teams building prospect lists and personalized outreach sequences.

**[Outreach](https://claude.com/connectors/outreach)** — Connects Claude to Outreach’s sales engagement platform, allowing it to draft sequences and reference sales activity data from live CRM records.

**[Similarweb](https://claude.com/connectors/similarweb)** — Brings Similarweb’s website traffic and competitive intelligence data into Claude. Useful for marketing, strategy, and M&A teams conducting competitive analysis.

**[MSCI](https://claude.com/connectors/msci)** — Provides direct access to MSCI’s proprietary index data, enabling queries on index performance, exposures, constituents, and methodologies within analysis workflows.

**[LegalZoom](https://claude.com/connectors/legalzoom)** — Connects Claude to LegalZoom’s legal document services, supporting business formation, compliance documentation, and legal workflow tasks.

**[FactSet](https://claude.com/connectors/factset)** — Brings FactSet’s real-time market data, fundamental analysis, earnings estimates, and institutional research insights into Claude for financial analysis workflows.

**[WordPress](https://claude.com/connectors/wordpress-com)** — Integrates with WordPress sites, enabling content creation, publishing management, and site-related workflows directly within Claude. Relevant for content and marketing teams publishing to WordPress-based properties.

**[Harvey](https://claude.com/connectors/harvey)** — Connects Claude to Harvey’s legal AI platform, deepening capabilities for law firms and in-house legal departments working across complex document and research tasks.

[Source](https://claude.com/blog/cowork-plugins-across-enterprise)

## All 10 New Pre-Built Plugins: Capabilities by Department

Anthropic released ten new pre-built plugin templates across knowledge work functions. Each was built with practitioners in the relevant field, meaning the skills, terminology, and output formats reflect how that function actually operates.

### [HR Plugin](https://claude.com/plugins/human-resources)

Covers people operations across the full employee lifecycle. Specific capabilities: drafting offer letters, building onboarding plans, writing performance reviews, and running compensation analyses. HR teams can customize the template to incorporate company-specific leveling frameworks, compensation bands, and internal policy language.

### [Design Plugin](https://claude.com/plugins/design)

Built for design teams, covering critique frameworks, UX copy drafting, accessibility audits, and user research planning. The accessibility audit capability is particularly practical given growing legal requirements around digital accessibility compliance across multiple markets.

### [Engineering Plugin](https://claude.com/plugins/engineering)

Targets day-to-day engineering workflows: standup summary generation, incident response coordination, deploy checklist creation, and postmortem drafting. These documentation tasks consume engineering time disproportionate to their complexity, making them natural candidates for automation.

### [Operations Plugin](https://claude.com/plugins/operations)

Addresses core business operations: process documentation, vendor evaluations, change request tracking, and runbook creation. Operations teams maintaining large volumes of internal documentation stand to benefit most from this template.

### [Brand Voice Plugin](https://claude.com/plugins/brand-voice) — by Tribe AI

Analyzes existing company documents, marketing materials, and internal communications to extract and codify the organization’s brand voice into clear, enforceable guidelines. Built by Tribe AI rather than Anthropic directly, it demonstrates the partner plugin model that Anthropic is actively expanding.

### [Financial Analysis Plugin](https://claude.com/plugins/financial-analysis)

Supports the baseline workflows that finance analysts use daily: market and competitive research, financial modeling, and PowerPoint template creation and quality checking. Available through [Anthropic’s public finance plugins repository on GitHub](https://github.com/anthropics/financial-services-plugins).

### [Investment Banking Plugin](https://claude.com/plugins/investment-banking)

Targets deal workflows specifically: reviewing transaction documents, building comparable company analyses, and preparing pitch materials. The plugin uses the standard terminology and output expectations of investment banking teams.

### [Equity Research Plugin](https://claude.com/plugins/equity-research)

Designed for analysts who process earnings transcripts, update financial models with new guidance, and draft research notes. It handles the volume-intensive nature of equity research workflows where speed and accuracy both matter.

### [Private Equity Plugin](https://claude.com/plugins/private-equity)

Supports deal sourcing and diligence: reviewing large document sets, extracting standardized financial data, modeling scenarios, and scoring opportunities against investment criteria. PE firms that process hundreds of potential deals per quarter will find the document review and financial extraction capabilities valuable.

### [Wealth Management Plugin](https://claude.com/plugins/wealth-management)

Helps advisors analyze client portfolios, identify portfolio drift and tax exposure, and generate rebalancing recommendations at scale. Especially relevant for advisors managing large numbers of accounts who need to run standardized analyses efficiently across their book of business.

All five finance-specific plugins are available at Anthropic’s [financial services plugins repository on GitHub](https://github.com/anthropics/financial-services-plugins) and can be installed directly or used as a customizable starting point. [Source](https://claude.com/blog/cowork-plugins-finance)

## Finance Gets a Dedicated Update: Partner Plugins and Institutional Data

The February 24 release includes a companion announcement specifically focused on financial services. [Source](https://claude.com/blog/cowork-plugins-finance) In addition to the five Anthropic-built finance plugins, two major financial data partners published plugins for their joint customers:

**[S&P Global Plugin](https://claude.com/plugins/sp-global)** — Brings Capital IQ Pro into Claude’s context. Skills include company tear sheets, industry transaction summaries, and earnings call previews — the exact data points deal and research teams reference daily.

**[LSEG Plugin](https://claude.com/plugins/lseg)** — Gives financial professionals direct access to LSEG’s market data and analytics from within Claude. Specific capabilities include building DCF models with live yield curves, drafting morning notes with real-time news, rebalancing portfolios with current cross-asset pricing, and analyzing deals with actual financing economics. Available to users with active LSEG data entitlements.

Two additional partner-built plugins also launched: the **[Apollo Plugin](https://claude.com/plugins/apollo)** and the **[Common Room Plugin](https://claude.com/plugins/common-room)**, extending Cowork’s reach into go-to-market and community intelligence workflows.

For teams working across Excel and PowerPoint — still the standard tools for financial analysis and presentation — Anthropic specifically designed the finance update around seamless cross-app workflows, described in the next section.

## Claude Working Across Excel and PowerPoint: What the Research Preview Covers

One of the more technically specific features in the February 24 update is the ability for Claude to handle multi-step tasks **end-to-end across Excel and PowerPoint**. This is currently available as a research preview for all paid plans on both Mac and Windows.

The core capability is context-passing between the two applications. Previously, if a financial analyst wanted Claude to run an analysis in Excel and then build a PowerPoint deck from the results, they had to copy outputs manually between applications and restart their Claude session each time they switched. With the new cross-app workflow, Claude retains context from one Office add-in to the other — meaning it knows what it analyzed in Excel when it begins building slides in PowerPoint.

A practical example from Anthropic’s own documentation: an equity analyst can ask Claude to analyze earnings, update a financial model, and build a summary slide — all without switching tools. When inputs change, Claude can automatically update the rest of the workflow. [Source](https://claude.com/blog/cowork-plugins-finance)

Anthropic has been transparent about the scope: this is described as “an early research preview that points toward Claude working across apps just like we do.” The company is not positioning this as a finished feature but as a directional demonstration of where cross-application AI assistance is heading.

To get started, download the add-in for [Claude in Excel](https://claude.com/claude-in-excel) and [Claude in PowerPoint](https://claude.com/claude-in-powerpoint). Both are available for all paid Claude plans.

## Real Enterprise Results: What Companies Are Actually Reporting

Anthropic’s February 24 briefing included three substantive enterprise case studies. These are worth examining because they provide the closest available evidence for what the platform can actually deliver — not what it promises.

**Spotify** — Spotify’s engineers had long dealt with the slow, manual work of code migrations: updating and modernizing code across thousands of services. After integrating Claude directly into the system Spotify’s engineers already use, any engineer can initiate a large-scale migration by describing what they need in plain language. Spotify reports up to a **90% reduction in engineering time**, over 650 AI-generated code changes shipped per month, and roughly half of all Spotify updates now flowing through the system. [Source](https://venturebeat.com/orchestration/anthropic-says-claude-code-transformed-programming-now-claude-cowork-is)

**Novo Nordisk** — The pharmaceutical company built an AI-powered platform called NovoScribe using Claude as its intelligence layer, targeting the grueling process of producing regulatory documentation for new medicines. Staff writers previously averaged just over two reports per year. After deploying Claude, documentation creation went from ten-plus weeks to ten minutes — a **95% reduction in resources** for verification checks. The team of eleven is operating like a significantly larger organization, with non-engineers contributing to platform development using natural language. [Source](https://venturebeat.com/orchestration/anthropic-says-claude-code-transformed-programming-now-claude-cowork-is)

**Salesforce** — Salesforce uses Claude models to help power AI features in Slack, reporting a **96% satisfaction rate** for tools like its Slack bot and saving customers an estimated **97 minutes per week** through summarization and recap features. [Source](https://venturebeat.com/orchestration/anthropic-says-claude-code-transformed-programming-now-claude-cowork-is)

These figures are self-reported by the organizations involved and should be understood in that context. They are, however, concrete benchmarks that enterprises evaluating Cowork can use as reference points.

## The PwC Partnership: Governance for Regulated Industries

Alongside the general enterprise update, Anthropic announced a collaboration with [PwC](https://www.pwc.com/us/en/about-us/newsroom/press-releases/pwc-anthropic-ai-native-finance-life-sciences-enterprise-agents.html) to accelerate enterprise AI deployment across regulated industries — specifically finance and healthcare/life sciences.

The PwC partnership addresses a specific gap that regulated enterprises face: technical capability exists, but the governance frameworks required to use it in a compliant environment do not yet exist in most organizations. PwC’s role is to provide that layer — redesigning workflows, embedding Responsible AI frameworks, and aligning Claude’s outputs with systems of record and regulatory requirements.

Sanjay Subramanian, PwC’s Anthropic Alliance Leader, described the strategic framing: _“Anthropic’s approach — where you organize specialized skills and ways of working with tools into plugins for a general agent — gives enterprises the performance they want with the flexibility to evolve their agent workflows much more easily.”_ [Source](https://www.pwc.com/us/en/about-us/newsroom/press-releases/pwc-anthropic-ai-native-finance-life-sciences-enterprise-agents.html)

Initial focus areas include:

- **AI Native Finance**: Strategic finance, liquidity forecasting, scenario modeling, and capital markets intelligence
- **Healthcare**: Governed AI agents embedded into utilization management, care coordination, revenue cycle, and population health workflows
- **Life Sciences**: Target identification, clinical design and delivery, regulatory submissions, and commercial content generation

Steve Haske from Thomson Reuters, whose CoCounsel legal product has reached one million users, was candid about the gap between technology capability and organizational readiness at the Anthropic enterprise briefing: _“The tools are in many senses ahead of the change management. A general counsel’s office, a law firm, a tax and accounting firm, an audit firm, need to rewire the processes to be able to take advantage of the benefits that the tools provide.”_ He estimated 18 months before change management broadly catches up with current tool capability. [Source](https://venturebeat.com/orchestration/anthropic-says-claude-code-transformed-programming-now-claude-cowork-is)

That observation applies well beyond legal. Any enterprise deploying Cowork should expect the technical implementation to outpace internal adoption. The private marketplace model — where IT controls what employees see — is partly a response to that reality.

## The Broader Market Context: What This Means Competitively

The February 24 launch accelerated a stock market reckoning that had been building since Cowork’s January 30 research preview. Companies whose software products overlap with Cowork’s capabilities faced significant pressure:

- IBM shares dropped **13.2%** in a single session the day before the Cowork update, following Anthropic’s separate blog post about using Claude to modernize COBOL — the programming language that runs IBM’s mainframe systems.
- Enterprise software stocks including ServiceNow, Salesforce, Snowflake, Intuit, and Thomson Reuters all experienced steep declines in the weeks following the initial Cowork announcement.
- Cybersecurity companies tumbled after Anthropic unveiled Claude Code Security on February 20.

However, the February 24 enterprise event triggered a partial reversal. Companies named as Anthropic partners and integration targets — Salesforce, DocuSign, LegalZoom, Thomson Reuters, FactSet — rallied, some sharply. Thomson Reuters surged more than **11%** on the day. [Source](https://venturebeat.com/orchestration/anthropic-says-claude-code-transformed-programming-now-claude-cowork-is)

The market signal is meaningful: organizations integrated into the Anthropic ecosystem appear positioned to benefit, while those standing outside it face a more uncertain outlook. That distinction is relevant for enterprises deciding whether to build on top of Cowork’s plugin architecture or maintain independent AI strategies.

Anthropic’s own economist, Peter McCrory, presented data from the [Anthropic Economic Index](https://www.anthropic.com/economic-index) showing that a year ago, roughly a third of all US jobs had at least a quarter of their associated tasks appearing in Claude usage data. That figure has now risen to approximately **one in every two jobs**. McCrory characterized AI as a “general purpose technology” in the economic sense — meaning virtually no sector is unaffected. [Source](https://venturebeat.com/orchestration/anthropic-says-claude-code-transformed-programming-now-claude-cowork-is)

He was specific about which roles face the most exposure: “jobs that are pure implementation” — citing data entry workers and technical writers — are areas where Claude is already being used for tasks central to those occupations. He was equally clear that no evidence of widespread labor displacement has materialized yet, and that the labor market implications will be uneven.

## Who Should Use Claude Cowork Plugins — And Who Isn’t Ready Yet

Not every organization is at the same starting point for Claude Cowork deployment. Here is an honest assessment of which enterprise contexts are best positioned to get value from the February 2026 updates immediately, and which need more groundwork first.

**Best positioned now:**

- **Finance teams** that already work in Excel, PowerPoint, and institutional data platforms like FactSet or MSCI. The connectors exist, the plugins exist, and the cross-app workflow is in research preview. The path from current state to deployed agent is shorter here than in almost any other function.
- **Legal teams** that use Thomson Reuters CoCounsel or Harvey and want to extend those capabilities with Claude’s reasoning across internal documents.
- **Engineering organizations** that have already adopted Claude Code and want to extend AI assistance to non-developer functions like operations, HR, or design.
- **Large enterprises** with dedicated IT administration teams who can manage plugin marketplace setup, per-user provisioning, and connector authorization properly.

**Organizations that need more preparation:**

- **Companies without structured data governance** — if the institutional knowledge Claude needs to execute sophisticated tasks exists only in people’s heads rather than in connected systems, as Anthropic’s economist noted, that is an organizational problem before it becomes a technical one. [Source](https://venturebeat.com/orchestration/anthropic-says-claude-code-transformed-programming-now-claude-cowork-is)
- **Heavily regulated industries** deploying without a governance framework — the PwC partnership exists because regulated enterprises need more than tool access; they need compliance architecture built around their AI workflows.
- **SMBs without internal IT administration capacity** — while the “Customize” menu is designed to be accessible, configuring a private plugin marketplace with appropriate controls still requires someone with the time and organizational access to do it properly.

## How to Get Started with Claude Cowork Plugins

Getting access to Cowork and its plugin features requires a paid Claude plan. Here is a clear breakdown of what is available at each level:

- **All Cowork users**: All user experience updates for plugins are available, including slash commands with structured forms and the company branding experience.
- **Team and Enterprise admins**: Access to company branding customization, per-user provisioning, MCP connector controls, and the private plugin marketplace.
- **All paid plans (Mac and Windows)**: Claude working across Excel and PowerPoint is available in research preview. Download the [Claude in Excel add-in](https://claude.com/claude-in-excel) and [Claude in PowerPoint add-in](https://claude.com/claude-in-powerpoint) to activate it.
- **Finance plugins**: Available publicly at [Anthropic’s financial services plugins GitHub repository](https://github.com/anthropics/financial-services-plugins). Installable directly or used as a template.
- **Connector setup**: Visit the connector directory in Claude’s settings. Admins can authorize connections and bundle them into plugins for their teams.

For enterprises focused specifically on financial services, Anthropic’s companion post provides additional detail on the finance-specific plugin configurations and FactSet/MSCI connector setup. [Source](https://claude.com/blog/cowork-plugins-finance)

## Detailed FAQ: Claude Cowork Enterprise Plugins

**Q1: What is Claude Cowork and how does it differ from regular Claude?**

Claude Cowork is Anthropic’s enterprise productivity platform built on top of the Claude AI model. Regular Claude ( [claude.ai](http://claude.ai/)) is a general-purpose AI assistant for individuals. Cowork adds enterprise features on top of Claude’s intelligence: multi-step workflow execution, MCP connectors that link to external enterprise software, plugin-based agent customization, private plugin marketplaces, admin controls, per-user provisioning, OpenTelemetry monitoring, and the ability to work across multiple applications like Excel and PowerPoint. It is designed for knowledge workers who need AI to complete whole deliverables — not just assist with individual tasks — within the software tools their organizations already use.

**Q2: What are Claude Cowork plugins exactly?**

Plugins are self-contained, portable file systems that bundle together three things: skills (specific behaviors and output formats), commands (slash commands that trigger structured workflows), and connectors (links to external data sources and tools). A plugin transforms Claude from a general assistant into a specialist for a particular job function. The HR plugin, for example, knows how to draft offer letters and performance reviews using the terminology and output standards HR teams expect. Plugins can be built by Anthropic, by third-party partners, or by an organization’s own team, and they are stored in files the organization owns outright.

**Q3: How does the private plugin marketplace work?**

Enterprise admins set up a private plugin marketplace through the new “Customize” menu in Cowork’s admin settings. They can populate the marketplace with Anthropic’s public plugins, partner-built plugins, or custom plugins they create from templates or from scratch. Claude guides the creation process through a conversational setup flow. Once plugins are in the marketplace, admins can control which employees have access using per-user provisioning, push plugins automatically to specific teams using auto-install, and restrict visibility so each team only sees the plugins relevant to their function. Organizations can also use private GitHub repositories as plugin sources, keeping custom code within their own infrastructure.

**Q4: What new connectors were added in February 2026?**

Twelve new MCP connectors were added: Google Calendar, Google Drive, Gmail, DocuSign, Apollo, Clay, Outreach, Similarweb, MSCI, LegalZoom, FactSet, WordPress, and Harvey. These are in addition to previously available connectors. Each connector allows Claude to pull live data from that platform into its working context and, where appropriate, write data back to it. The connector directory in Claude’s settings shows the full current list with one-click authorization for admins.

**Q5: What is MCP, and why does it matter for enterprise integrations?**

MCP stands for Model Context Protocol — an open standard that Anthropic introduced in late 2024 for connecting AI systems to external data sources and tools. It functions similarly to how USB provides a universal standard for connecting hardware: instead of building a custom integration for every combination of AI model and software tool, MCP allows any MCP-compatible AI to connect to any MCP-compatible tool. This means Claude connectors are not proprietary integrations that lock enterprises into Anthropic’s infrastructure. They can connect Claude to new tools as they become available, and enterprises can build their own MCP connectors for internal systems that Anthropic doesn’t support natively.

**Q6: Can enterprises build their own custom plugins without coding?**

Yes. The plugin creation flow in the “Customize” menu walks admins through setup via a question-and-answer process guided by Claude itself. Admins define what the plugin should do, what data sources it needs, and what workflows it should support — in plain language. Claude assembles the plugin configuration based on those answers. For more advanced customization, teams with development resources can build plugins using code and publish them through private GitHub repositories (in private beta). Both paths are available, meaning technical and non-technical teams can create plugins at different levels of sophistication.

**Q7: Which departments and job functions have pre-built plugins available?**

As of February 24, 2026, Anthropic’s pre-built plugin templates cover: HR, Design, Engineering, Operations, Brand Voice (by Tribe AI), Financial Analysis, Investment Banking, Equity Research, Private Equity, and Wealth Management. Partner-built plugins from Slack by Salesforce, LSEG, S&P Global, Apollo, and Common Room are also available for joint customers. Additional plugins are accessible through Anthropic’s public GitHub repositories. New templates are expected as Anthropic expands the library.

**Q8: How does Claude working across Excel and PowerPoint actually function?**

The feature requires downloading two Microsoft Office add-ins: Claude in Excel and Claude in PowerPoint. Once both are installed, Claude can be given a multi-step task that spans both applications — for example, analyzing financial data in an Excel spreadsheet and then generating a PowerPoint presentation based on the analysis. Claude retains context between the two applications, meaning it does not need to be re-briefed when the user switches from Excel to PowerPoint. When inputs in the spreadsheet change, Claude can update the rest of the workflow accordingly. This is currently in research preview for all paid plans on Mac and Windows.

**Q9: What is OpenTelemetry support and why does it matter for enterprise IT?**

OpenTelemetry is a widely adopted open-source observability framework used across enterprise software to collect usage, performance, and cost data. With OpenTelemetry support added to Cowork, admins can now track usage patterns, tool activity, and operational costs across their teams within existing enterprise monitoring dashboards and SIEM (Security Information and Event Management) systems — without building custom integrations. This is significant for compliance and cost management in large organizations, where understanding who is using which AI capabilities, at what frequency and cost, is a governance requirement rather than an optional nice-to-have.

**Q10: What is the difference between a connector and a plugin in Cowork?**

A connector is a single integration link between Claude and one external tool (e.g., the FactSet connector or the Gmail connector). It allows Claude to read from or interact with that specific platform. A plugin is a higher-level bundle that can include multiple connectors plus skills and commands, all configured together for a specific job function. The Investment Banking plugin, for example, might include connectors to FactSet and S&P Global, plus a set of deal-review skills and slash commands tailored to bankers, all packaged into a single deployable agent. Think of connectors as components and plugins as complete specialized agents built from those components.

**Q11: How does Anthropic handle data security and privacy for Cowork enterprise deployments?**

Enterprise admins have explicit control over connector authorizations — only connectors they approve are active for their organization. Private plugin marketplaces mean custom code stays within the organization’s infrastructure (especially when using private GitHub as a source). OpenTelemetry monitoring provides audit trails for AI activity. For regulated industries, Anthropic’s partnership with PwC is specifically designed to overlay governance frameworks, Responsible AI practices, and compliance controls on top of the technical deployment. Anthropic has also described working with Thomson Reuters on an “ironclad guarantee” that customer input will not be part of their AI outputs — a model that reflects the contractual protections enterprises in sensitive industries require.

**Q12: Is Claude Cowork available to small businesses, or is it enterprise-only?**

The base user experience updates — including slash command forms and plugin access — are available to all Cowork users across paid plans. Private plugin marketplaces, per-user provisioning, company branding, and advanced MCP controls are features available to Team and Enterprise admins, which are tiers designed for organizations rather than individuals. Small businesses with a Team plan can access meaningful plugin functionality, though the full private marketplace and governance features require an Enterprise plan.

**Q13: How does Claude Cowork compare to Microsoft Copilot or Google Workspace AI?**

Microsoft Copilot for Microsoft 365 and Google Workspace AI (Gemini) are both deeply integrated into their respective productivity suites. Claude Cowork’s differentiating position is its open MCP connector architecture, which allows it to integrate with tools outside any single vendor’s ecosystem (including connecting to Microsoft’s own Excel and PowerPoint), and its private plugin marketplace model, which gives enterprises more flexibility to build domain-specific agents than the more standardized feature sets of Copilot and Gemini. The trade-off is that Cowork requires more setup and admin configuration than built-in productivity suite AI features, which have lower deployment friction for organizations already fully committed to Microsoft 365 or Google Workspace. The “right” tool depends on an organization’s existing infrastructure, governance requirements, and the complexity of the workflows they need to automate.

**Q14: What does the PwC–Anthropic collaboration actually deliver to enterprises?**

PwC and Anthropic announced a collaboration on February 24, 2026 to help enterprises in regulated industries — specifically finance and healthcare/life sciences — deploy Cowork plugins within compliant governance frameworks. PwC provides workflow redesign, Responsible AI framework integration, and alignment with regulatory requirements, while Anthropic provides the technical platform and models (including Claude Opus 4.6 and Sonnet 4.6). The deliverables include industry-specific skills, connectors, and plugins tailored to finance, healthcare, and life sciences that go beyond Anthropic’s general-purpose templates. Enterprises in regulated industries interested in deployment at scale should consider engaging through this collaboration rather than self-deploying, given the governance complexity involved.

**Q15: How do Cowork plugins work with the Claude Agent SDK?**

Plugins are designed to be portable and interoperable across both Cowork and anything built on the [Claude Agent SDK](https://www.anthropic.com/). This means a plugin built for internal Cowork use can also be deployed in custom applications built by developers using the Agent SDK. The portability matters for enterprises that want to build their own Claude-powered products or internal tools rather than relying entirely on the Cowork interface. An organization could, for example, build an internal client portal that uses the same Wealth Management plugin their advisors use inside Cowork — without rebuilding the plugin logic.

**Q16: Are the finance plugins available for free or do they require additional licensing?**

All five Anthropic-built finance plugins (Financial Analysis, Investment Banking, Equity Research, Private Equity, and Wealth Management) are open source and available at no additional cost through [Anthropic’s public GitHub repository](https://github.com/anthropics/financial-services-plugins). They can be installed directly into a Cowork instance or used as a base for custom development. Partner-built plugins from LSEG and S&P Global, however, require active data entitlements with those providers respectively. The FactSet and MSCI connectors similarly require existing FactSet and MSCI subscriptions to function.

**Q17: What is “the thinking divide” that Anthropic’s head of Americas referenced?**

Kate Jensen used the term “the thinking divide” at Anthropic’s February 24 enterprise briefing to describe the growing gap between organizations that embed AI systematically — across employees, processes, and products simultaneously — and those that use it as a point solution for individual tasks. Her argument was that organizations on the systematic side compound their advantage over time in productivity, speed, and decision quality, while those on the point-solution side fall progressively further behind. The Cowork plugin architecture, by enabling department-specific agents distributed across an entire organization, is Anthropic’s technical answer to the question of how organizations get onto the systematic side of that divide.

**Q18: How long does it take to set up a private plugin marketplace for an enterprise?**

Anthropic hasn’t published official setup time estimates, but the design intention of the “Customize” menu and Claude-guided plugin creation is to make setup accessible to IT admins without specialized AI development knowledge. Organizations starting from Anthropic’s pre-built templates — which cover ten departments out of the box — can deploy those templates with connector authorizations and per-user provisioning configured in hours to days. Building fully custom plugins tailored to proprietary workflows, integrating with internal systems, and rolling out to thousands of users across multiple departments is a more involved project — typically measured in weeks to months depending on organizational complexity and the depth of customization required.

## The Practical Takeaway for Enterprise Leaders

The February 24 Claude Cowork update is the clearest signal yet that the enterprise AI market is moving from generic productivity tools toward deeply specialized, workflow-embedded agents. Every piece of the update — private marketplaces, per-user provisioning, OpenTelemetry monitoring, department-specific plugins, institutional data connectors — is a direct response to the specific barriers that kept enterprise AI stuck in pilot mode through 2025.

The results reported by Spotify (90% reduction in engineering migration time), Novo Nordisk (10-plus weeks of documentation work reduced to ten minutes), and Salesforce (97 minutes saved per employee per week) are the benchmarks enterprises will now hold Cowork against in their own environments. [Source](https://venturebeat.com/orchestration/anthropic-says-claude-code-transformed-programming-now-claude-cowork-is)

That doesn’t mean every enterprise is ready to deploy immediately. As Thomson Reuters’ Steve Haske noted, change management in most organizations is still 18 months behind the tools. Getting Claude into production at scale requires answering the organizational questions first — data governance, workflow redesign, governance frameworks, human-in-the-loop controls — before the technical questions. Anthropic’s answer to that challenge is twofold: a simplified plugin architecture that IT teams can manage without AI expertise, and the PwC partnership for regulated industries that need structured implementation support.

For enterprises that have done the groundwork, the combination of private marketplaces, portable plugins, MCP connectors, and cross-app Excel/PowerPoint workflows makes the February 24 update a meaningful step toward deploying AI that actually behaves like a member of each team — rather than a general tool that teams have to adapt themselves to. That shift, when it happens, is what enterprise AI adoption has been waiting for.

## Frequently Referenced Sources

- Anthropic: [Cowork and Plugins for Teams Across the Enterprise](https://claude.com/blog/cowork-plugins-across-enterprise) — February 24, 2026
- Anthropic: [Cowork and Plugins for Financial Services](https://claude.com/blog/cowork-plugins-finance) — February 24, 2026
- VentureBeat: [Anthropic Says Claude Code Transformed Programming. Now Claude Cowork Is Coming for the Rest of the Enterprise](https://venturebeat.com/orchestration/anthropic-says-claude-code-transformed-programming-now-claude-cowork-is)
- Forbes: [Anthropic Leans Into Enterprise With Managed Claude Cowork Plugins](https://www.forbes.com/sites/ronschmelzer/2026/02/25/anthropic-leans-into-enterprise-ai-agents-that-fit-business-workflow/)
- CNBC: [Anthropic Updates Claude Cowork Tool Built to Give the Average Office Worker a Productivity Boost](https://www.cnbc.com/2026/02/24/anthropic-claude-cowork-office-worker.html)
- TechCrunch: [Anthropic Launches New Push for Enterprise Agents with Plugins for Finance, Engineering, and Design](https://techcrunch.com/2026/02/24/anthropic-launches-new-push-for-enterprise-agents-with-plugins-for-finance-engineering-and-design/)
- PwC: [PwC and Anthropic Collaborate on Enterprise Agents](https://www.pwc.com/us/en/about-us/newsroom/press-releases/pwc-anthropic-ai-native-finance-life-sciences-enterprise-agents.html)
- Anthropic Finance Plugins GitHub: [financial-services-plugins](https://github.com/anthropics/financial-services-plugins)

## About ALM Corp

[ALM Corp](https://almcorp.com/) is a white-label digital marketing and AI solutions agency that has been helping agencies and enterprise clients generate measurable results since 2006. With over 30,000 satisfied clients and partnerships with more than 1,000 agencies worldwide, ALM Corp specializes in exactly the kind of strategic AI integration that the Claude Cowork plugin ecosystem demands.

As enterprise AI moves from pilot to production — with platforms like Claude Cowork now offering private plugin marketplaces, MCP connectors, and department-specific agents — the critical success factor is not just access to the technology. It is having the marketing intelligence, workflow expertise, and implementation experience to deploy AI where it actually generates business outcomes. ALM Corp’s [AI marketing and automation services](https://almcorp.com/services/technology/artificial-intelligence-ai/) are built for this moment: helping organizations deploy predictive analytics, content automation, recommendation engines, and conversational AI across their operations in ways that reduce costs, improve accuracy, and deliver measurable ROI.

Whether you are a digital agency looking to offer Claude Cowork deployment as a white-label service to clients, or an enterprise ready to move beyond AI pilots into production-grade agentic workflows, ALM Corp has the team and the track record to support that transition. Explore ALM Corp’s AI services at [almcorp.com](https://almcorp.com/) or reach out for a free growth strategy consultation.

About The Author

![Alm corp logo](https://almcorp.com/wp-content/uploads/2025/05/Alm-corp-logo.webp)

[ALM Corp](https://almcorp.com/blog/author/alm-corp/)

At ALM Corp, we deliver innovative, results-driven digital marketing solutions designed to elevate your brand, engage your audience, and accelerate your growth. Welcome to a partnership where your business ambitions meet our strategic digital expertise. In a rapidly evolving online landscape, we stand as your steadfast partner, committed to navigating complexities and unlocking new opportunities for your brand.

Latest Posts

[View All Posts](https://almcorp.com/blog/)

[![Meta Simplifies Ad Performance Elements](https://almcorp.com/wp-content/uploads/elementor/thumbs/Meta-Simplifies-Ad-Performance-Elements-rm2nrvxkrzyj149f7kjpg2o2n0nzu14me84fml2j94.webp)](https://almcorp.com/blog/meta-simplifies-ad-performance-elements/)

- [Online Marketing](https://almcorp.com/blog/category/online-marketing/)

- 10 mins read

[Meta Simplifies Ad Performance Elements: What the New Pixel and Conversions API Updates Mean for Advertisers](https://almcorp.com/blog/meta-simplifies-ad-performance-elements/)

- Vineesh Sandhir

[![LinkedIn Is the #1 AI Citation Source for B2B](https://almcorp.com/wp-content/uploads/elementor/thumbs/LinkedIn-Is-the-1-AI-Citation-Source-for-B2B-rm2n1yju9igssbx7lv36647cregiil75twba2tigvs.webp)](https://almcorp.com/blog/linkedin-ai-citation-source-b2b-ai-discoverability/)

- [AI](https://almcorp.com/blog/category/ai/)

- 9 mins read

[LinkedIn Is the #1 AI Citation Source for B2B: How to Optimize for AI Discoverability Across Google AI Overviews, ChatGPT, and Perplexity](https://almcorp.com/blog/linkedin-ai-citation-source-b2b-ai-discoverability/)

- ALM Corp

[![dd1bee7f-b3b6-4d9a-9382-dc23bc9e8a4a](https://almcorp.com/wp-content/uploads/elementor/thumbs/dd1bee7f-b3b6-4d9a-9382-dc23bc9e8a4a-rm2n70wj3defcokc11wslu6s05hpzvb36yvh6i03co.webp)](https://almcorp.com/blog/high-intent-seo-keywords-2026-buy-hire-vs-high-volume/)

- [SEO](https://almcorp.com/blog/category/seo/)

- 10 mins read

[High-Intent SEO Keywords for 2026: Why “Buy” and “Hire” Queries Beat High-Volume Terms for Leads, Sales, and ROI](https://almcorp.com/blog/high-intent-seo-keywords-2026-buy-hire-vs-high-volume/)

- ALM Corp