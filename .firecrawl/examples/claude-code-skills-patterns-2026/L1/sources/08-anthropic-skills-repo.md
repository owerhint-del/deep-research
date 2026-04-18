[Skip to content](https://github.com/anthropics/skills#start-of-content)

You signed in with another tab or window. [Reload](https://github.com/anthropics/skills) to refresh your session.You signed out in another tab or window. [Reload](https://github.com/anthropics/skills) to refresh your session.You switched accounts on another tab or window. [Reload](https://github.com/anthropics/skills) to refresh your session.Dismiss alert

{{ message }}

[anthropics](https://github.com/anthropics)/ **[skills](https://github.com/anthropics/skills)** Public

- [Notifications](https://github.com/login?return_to=%2Fanthropics%2Fskills) You must be signed in to change notification settings
- [Fork\\
13.9k](https://github.com/login?return_to=%2Fanthropics%2Fskills)
- [Star\\
120k](https://github.com/login?return_to=%2Fanthropics%2Fskills)


main

[Branches](https://github.com/anthropics/skills/branches) [Tags](https://github.com/anthropics/skills/tags)

[Go to Branches page](https://github.com/anthropics/skills/branches)[Go to Tags page](https://github.com/anthropics/skills/tags)

Go to file

Code

Open more actions menu

## Folders and files

| Name | Name | Last commit message | Last commit date |
| --- | --- | --- | --- |
| ## Latest commit<br>## History<br>[29 Commits](https://github.com/anthropics/skills/commits/main/) <br>[View commit history for this file.](https://github.com/anthropics/skills/commits/main/) 29 Commits |
| [.claude-plugin](https://github.com/anthropics/skills/tree/main/.claude-plugin ".claude-plugin") | [.claude-plugin](https://github.com/anthropics/skills/tree/main/.claude-plugin ".claude-plugin") |  |  |
| [skills](https://github.com/anthropics/skills/tree/main/skills "skills") | [skills](https://github.com/anthropics/skills/tree/main/skills "skills") |  |  |
| [spec](https://github.com/anthropics/skills/tree/main/spec "spec") | [spec](https://github.com/anthropics/skills/tree/main/spec "spec") |  |  |
| [template](https://github.com/anthropics/skills/tree/main/template "template") | [template](https://github.com/anthropics/skills/tree/main/template "template") |  |  |
| [.gitignore](https://github.com/anthropics/skills/blob/main/.gitignore ".gitignore") | [.gitignore](https://github.com/anthropics/skills/blob/main/.gitignore ".gitignore") |  |  |
| [README.md](https://github.com/anthropics/skills/blob/main/README.md "README.md") | [README.md](https://github.com/anthropics/skills/blob/main/README.md "README.md") |  |  |
| [THIRD\_PARTY\_NOTICES.md](https://github.com/anthropics/skills/blob/main/THIRD_PARTY_NOTICES.md "THIRD_PARTY_NOTICES.md") | [THIRD\_PARTY\_NOTICES.md](https://github.com/anthropics/skills/blob/main/THIRD_PARTY_NOTICES.md "THIRD_PARTY_NOTICES.md") |  |  |
| View all files |

## Repository files navigation

> **Note:** This repository contains Anthropic's implementation of skills for Claude. For information about the Agent Skills standard, see [agentskills.io](http://agentskills.io/).

# Skills

[Permalink: Skills](https://github.com/anthropics/skills#skills)

Skills are folders of instructions, scripts, and resources that Claude loads dynamically to improve performance on specialized tasks. Skills teach Claude how to complete specific tasks in a repeatable way, whether that's creating documents with your company's brand guidelines, analyzing data using your organization's specific workflows, or automating personal tasks.

For more information, check out:

- [What are skills?](https://support.claude.com/en/articles/12512176-what-are-skills)
- [Using skills in Claude](https://support.claude.com/en/articles/12512180-using-skills-in-claude)
- [How to create custom skills](https://support.claude.com/en/articles/12512198-creating-custom-skills)
- [Equipping agents for the real world with Agent Skills](https://anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)

# About This Repository

[Permalink: About This Repository](https://github.com/anthropics/skills#about-this-repository)

This repository contains skills that demonstrate what's possible with Claude's skills system. These skills range from creative applications (art, music, design) to technical tasks (testing web apps, MCP server generation) to enterprise workflows (communications, branding, etc.).

Each skill is self-contained in its own folder with a `SKILL.md` file containing the instructions and metadata that Claude uses. Browse through these skills to get inspiration for your own skills or to understand different patterns and approaches.

Many skills in this repo are open source (Apache 2.0). We've also included the document creation & editing skills that power [Claude's document capabilities](https://www.anthropic.com/news/create-files) under the hood in the [`skills/docx`](https://github.com/anthropics/skills/blob/main/skills/docx), [`skills/pdf`](https://github.com/anthropics/skills/blob/main/skills/pdf), [`skills/pptx`](https://github.com/anthropics/skills/blob/main/skills/pptx), and [`skills/xlsx`](https://github.com/anthropics/skills/blob/main/skills/xlsx) subfolders. These are source-available, not open source, but we wanted to share these with developers as a reference for more complex skills that are actively used in a production AI application.

## Disclaimer

[Permalink: Disclaimer](https://github.com/anthropics/skills#disclaimer)

**These skills are provided for demonstration and educational purposes only.** While some of these capabilities may be available in Claude, the implementations and behaviors you receive from Claude may differ from what is shown in these skills. These skills are meant to illustrate patterns and possibilities. Always test skills thoroughly in your own environment before relying on them for critical tasks.

# Skill Sets

[Permalink: Skill Sets](https://github.com/anthropics/skills#skill-sets)

- [./skills](https://github.com/anthropics/skills/blob/main/skills): Skill examples for Creative & Design, Development & Technical, Enterprise & Communication, and Document Skills
- [./spec](https://github.com/anthropics/skills/blob/main/spec): The Agent Skills specification
- [./template](https://github.com/anthropics/skills/blob/main/template): Skill template

# Try in Claude Code, Claude.ai, and the API

[Permalink: Try in Claude Code, Claude.ai, and the API](https://github.com/anthropics/skills#try-in-claude-code-claudeai-and-the-api)

## Claude Code

[Permalink: Claude Code](https://github.com/anthropics/skills#claude-code)

You can register this repository as a Claude Code Plugin marketplace by running the following command in Claude Code:

```
/plugin marketplace add anthropics/skills
```

Then, to install a specific set of skills:

1. Select `Browse and install plugins`
2. Select `anthropic-agent-skills`
3. Select `document-skills` or `example-skills`
4. Select `Install now`

Alternatively, directly install either Plugin via:

```
/plugin install document-skills@anthropic-agent-skills
/plugin install example-skills@anthropic-agent-skills
```

After installing the plugin, you can use the skill by just mentioning it. For instance, if you install the `document-skills` plugin from the marketplace, you can ask Claude Code to do something like: "Use the PDF skill to extract the form fields from `path/to/some-file.pdf`"

## Claude.ai

[Permalink: Claude.ai](https://github.com/anthropics/skills#claudeai)

These example skills are all already available to paid plans in Claude.ai.

To use any skill from this repository or upload custom skills, follow the instructions in [Using skills in Claude](https://support.claude.com/en/articles/12512180-using-skills-in-claude#h_a4222fa77b).

## Claude API

[Permalink: Claude API](https://github.com/anthropics/skills#claude-api)

You can use Anthropic's pre-built skills, and upload custom skills, via the Claude API. See the [Skills API Quickstart](https://docs.claude.com/en/api/skills-guide#creating-a-skill) for more.

# Creating a Basic Skill

[Permalink: Creating a Basic Skill](https://github.com/anthropics/skills#creating-a-basic-skill)

Skills are simple to create - just a folder with a `SKILL.md` file containing YAML frontmatter and instructions. You can use the **template-skill** in this repository as a starting point:

```
---
name: my-skill-name
description: A clear description of what this skill does and when to use it
---

# My Skill Name

[Add your instructions here that Claude will follow when this skill is active]

## Examples
- Example usage 1
- Example usage 2

## Guidelines
- Guideline 1
- Guideline 2
```

The frontmatter requires only two fields:

- `name` \- A unique identifier for your skill (lowercase, hyphens for spaces)
- `description` \- A complete description of what the skill does and when to use it

The markdown content below contains the instructions, examples, and guidelines that Claude will follow. For more details, see [How to create custom skills](https://support.claude.com/en/articles/12512198-creating-custom-skills).

# Partner Skills

[Permalink: Partner Skills](https://github.com/anthropics/skills#partner-skills)

Skills are a great way to teach Claude how to get better at using specific pieces of software. As we see awesome example skills from partners, we may highlight some of them here:

- **Notion** \- [Notion Skills for Claude](https://www.notion.so/notiondevs/Notion-Skills-for-Claude-28da4445d27180c7af1df7d8615723d0)

## About

Public repository for Agent Skills


### Topics

[agent-skills](https://github.com/topics/agent-skills "Topic: agent-skills")

### Resources

[Readme](https://github.com/anthropics/skills#readme-ov-file)

### Uh oh!

There was an error while loading. [Please reload this page](https://github.com/anthropics/skills).

[Activity](https://github.com/anthropics/skills/activity)

[Custom properties](https://github.com/anthropics/skills/custom-properties)

### Stars

[**120k**\\
stars](https://github.com/anthropics/skills/stargazers)

### Watchers

[**816**\\
watching](https://github.com/anthropics/skills/watchers)

### Forks

[**13.9k**\\
forks](https://github.com/anthropics/skills/forks)

[Report repository](https://github.com/contact/report-content?content_url=https%3A%2F%2Fgithub.com%2Fanthropics%2Fskills&report=anthropics+%28user%29)

## [Releases](https://github.com/anthropics/skills/releases)

No releases published

## [Packages\  0](https://github.com/orgs/anthropics/packages?repo_name=skills)

### Uh oh!

There was an error while loading. [Please reload this page](https://github.com/anthropics/skills).

### Uh oh!

There was an error while loading. [Please reload this page](https://github.com/anthropics/skills).

## [Contributors\  14](https://github.com/anthropics/skills/graphs/contributors)

- [![@klazuka](https://avatars.githubusercontent.com/u/84525?s=64&v=4)](https://github.com/klazuka)
- [![@claude](https://avatars.githubusercontent.com/u/81847?s=64&v=4)](https://github.com/claude)
- [![@ericharmeling](https://avatars.githubusercontent.com/u/27286675?s=64&v=4)](https://github.com/ericharmeling)
- [![@maheshmurag](https://avatars.githubusercontent.com/u/5667029?s=64&v=4)](https://github.com/maheshmurag)
- [![@github-actions[bot]](https://avatars.githubusercontent.com/in/15368?s=64&v=4)](https://github.com/apps/github-actions)
- [![@mattpic-ant](https://avatars.githubusercontent.com/u/227474486?s=64&v=4)](https://github.com/mattpic-ant)
- [![@cc-skill-sync[bot]](https://avatars.githubusercontent.com/u/76263028?s=64&v=4)](https://github.com/apps/cc-skill-sync)
- [![@kencheeto](https://avatars.githubusercontent.com/u/279406?s=64&v=4)](https://github.com/kencheeto)
- [![@camaris](https://avatars.githubusercontent.com/u/1184736?s=64&v=4)](https://github.com/camaris)
- [![@quuu](https://avatars.githubusercontent.com/u/32676955?s=64&v=4)](https://github.com/quuu)
- [![@allenzhou101](https://avatars.githubusercontent.com/u/46854522?s=64&v=4)](https://github.com/allenzhou101)
- [![@zack-anthropic](https://avatars.githubusercontent.com/u/139395547?s=64&v=4)](https://github.com/zack-anthropic)
- [![@peterlai-ant](https://avatars.githubusercontent.com/u/216783784?s=64&v=4)](https://github.com/peterlai-ant)
- [![@ant-andi](https://avatars.githubusercontent.com/u/218842397?s=64&v=4)](https://github.com/ant-andi)

## Languages

- [Python84.4%](https://github.com/anthropics/skills/search?l=python)
- [HTML12.4%](https://github.com/anthropics/skills/search?l=html)
- [Shell1.9%](https://github.com/anthropics/skills/search?l=shell)
- [JavaScript1.3%](https://github.com/anthropics/skills/search?l=javascript)

You can’t perform that action at this time.