[Back to Marketplaces](https://www.claudepluginhub.com/marketplaces)

Marketplace

# claude-skills

Production-tested skills for Claude Code - Cloudflare, AI, React, Tailwind v4, and modern web development

## Component Overview

59

Commands

46

Agents

211

Skills

2

Hooks

3

MCP Servers

0

LSP Servers

0

Output Styles

## Install

Quick InstallManual Install

$

```
npx claudepluginhub secondsky/claude-skills
```

## README

## Claude Code Skills Collection

**170 production-ready skills for Claude Code CLI**

Version 3.2.1 \| Last Updated: 2026-04-01

<div align="center">

**🔌 Platform Support**

This repository uses **Claude Plugin Patterns** — natively supported by:

| Platform | Status | Notes |
| --- | --- | --- |
| **Claude Code** | ✅ **Native** | Full marketplace support |
| **Factory Droid** | ✅ **Native** | Full marketplace support |

</div>
\*\*For all other Platforms like opencode, codex and others, you can use https://github.com/enulus/OpenPackage
\*\*

* * *

A curated collection of battle-tested skills for building modern web applications with Cloudflare, AI integrations, React, Tailwind, and more.

PS: if skills.sh warns about any skill: Their scan process is a outdated LLM which flags newest versions pins (like in ZOD) as non existent and by that potentially malicous.

* * *

### Quick Start

#### Marketplace Installation (Recommended)

```bash
# Add the marketplace
/plugin marketplace add https://github.com/secondsky/claude-skills

# Install individual skills as needed
/plugin install cloudflare-d1@claude-skills
/plugin install tailwind-v4-shadcn@claude-skills
/plugin install ai-sdk-core@claude-skills
```

See [MARKETPLACE.md](https://www.claudepluginhub.com/marketplaces/MARKETPLACE.md) for complete catalog of all 170 skills.

#### Bulk Installation (Contributors)

```bash
# Clone the repository
git clone https://github.com/secondsky/claude-skills.git
cd claude-skills

# Install all 170 skills at once
./scripts/install-all.sh

# Or install individual skills
./scripts/install-skill.sh cloudflare-d1
```

* * *

### Repository Structure

This repository contains **170 production-tested skills** for Claude Code, each focused on a specific technology or capability.

**Individual Skills**: Each skill is a standalone unit with:

- `SKILL.md` \- Core knowledge and guidance
- Templates - Working code examples
- References - Extended documentation
- Scripts - Helper utilities

**Installation Options**:

1. **Individual** \- Install only the skills you need via marketplace
2. **Bulk** \- Install all 170 skills using `./scripts/install-all.sh`

* * *

### Available Skills (170 Individual Skills)

Each skill is individually installable. Install only the skills you need.

**Full Catalog**: See [MARKETPLACE.md](https://www.claudepluginhub.com/marketplaces/MARKETPLACE.md) for detailed listings.

#### Categories

| Category | Skills | Examples |
| --- | --- | --- |
| **tooling** | 29 | turborepo, plan-interview, code-review |
| **frontend** | 26 | nuxt-v4, nuxt-v5, tailwind-v4-shadcn, tanstack-query, nuxt-studio, maz-ui, threejs |
| **cloudflare** | 21 | cloudflare-d1, cloudflare-workers-ai, cloudflare-agents |
| **ai** | 20 | openai-agents, claude-api, ai-sdk-core |
| **api** | 16 | api-design-principles, graphql-implementation |
| **web** | 10 | hono-routing, firecrawl-scraper, web-performance |
| **mobile** | 7 | swift-best-practices, react-native-app, react-native-skills |
| **database** | 6 | drizzle-orm-d1, neon-vercel-postgres, supabase-postgres-best-practices |
| **security** | 6 | csrf-protection, access-control-rbac |
| **auth** | 4 | better-auth |
| **testing** | 4 | vitest-testing, playwright-testing |
| **design** | 4 | design-review, design-system-creation |
| **woocommerce** | 4 | woocommerce-backend-dev |
| **cms** | 4 | hugo, sveltia-cms, wordpress-plugin-core |
| **architecture** | 3 | microservices-patterns, architecture-patterns |
| **data** | 3 | sql-query-optimization, recommendation-engine |
| **seo** | 2 | seo-optimizer, seo-keyword-cluster-builder |
| **documentation** | 1 | technical-specification |

* * *

### How It Works

#### Auto-Discovery

Claude Code automatically checks `~/.claude/skills/` for relevant skills before planning tasks:

```
User: "Set up a Cloudflare Worker with D1 database"
           ↓
Claude: [Checks skills automatically]
           ↓
Claude: "Found cloudflare-d1 skills.
         These prevent 12 documented errors. Use them?"
           ↓
User: "Yes"
           ↓
Result: Production-ready setup, zero errors, ~65% token savings
```

**Note**: Due to token limits, not all skills may be visible at once. See [⚠️ Important: Token Limits](https://www.claudepluginhub.com/marketplaces/secondsky-claude-skills#-important-token-limits) below.

#### Skill Structure

Each skill includes:

```
skills/[skill-name]/
├── SKILL.md              # Complete documentation
├── .claude-plugin/
│   └── plugin.json       # Plugin metadata
├── templates/            # Ready-to-copy templates
├── scripts/              # Automation scripts
└── references/           # Extended documentation
```

* * *

### Recent Additions

#### February - April 2026

**Full-Stack Frameworks**:

- **nuxt-v5** (v1.0.0) - Full Nuxt 5 support with 4 skills (core, data, server, production), 3 diagnostic agents, and interactive setup wizard
- **supabase-postgres-best-practices** \- 30 Postgres optimization rules from Supabase across 8 categories
- **threejs** (v1.0.0) - 3D web graphics: scenes, geometries, shaders, animations, post-processing

[View full README on GitHub](https://github.com/secondsky/claude-skills)

## 170 Plugins

## access-control-rbac

99

Role-based access control (RBAC) with permissions and policies. Use for admin dashboards, enterprise access, multi-tenant apps, fine-grained authorization, or encountering permission hierarchies, role inheritance, policy conflicts.

2w

v3.0.0

[View access-control-rbac](https://www.claudepluginhub.com/plugins/secondsky-access-control-rbac-plugins-access-control-rbac-2)

## aceternity-ui

99

100+ animated React components (Aceternity UI) for Next.js with Tailwind. Use for hero sections, parallax, 3D effects, or encountering animation, shadcn CLI integration errors.

2w

v3.0.0

[View aceternity-ui](https://www.claudepluginhub.com/plugins/secondsky-aceternity-ui-plugins-aceternity-ui-2)

## ai-elements-chatbot

99

shadcn/ui AI chat components for conversational interfaces. Use for streaming chat, tool/function displays, reasoning visualization, or encountering Next.js App Router setup, Tailwind v4 integration, AI SDK v5 migration errors.

3mo

v3.0.0

[View ai-elements-chatbot](https://www.claudepluginhub.com/plugins/secondsky-ai-elements-chatbot-plugins-ai-elements-chatbot-2)

## ai-sdk-core

99

Vercel AI SDK v5 for backend AI (text generation, structured output, tools, agents). Multi-provider. Use for server-side AI or encountering AI\_APICallError, AI\_NoObjectGeneratedError, streaming failures.

3mo

v3.0.0

[View ai-sdk-core](https://www.claudepluginhub.com/plugins/secondsky-ai-sdk-core-plugins-ai-sdk-core-2)

## ai-sdk-ui

99

Vercel AI SDK v5 React hooks (useChat, useCompletion, useObject) for AI chat interfaces. Use for React/Next.js AI apps or encountering parse stream errors, no response, streaming issues.

4w

v3.0.0

[View ai-sdk-ui](https://www.claudepluginhub.com/plugins/secondsky-ai-sdk-ui-plugins-ai-sdk-ui-2)

## api-authentication

99

Secure API authentication with JWT, OAuth 2.0, API keys. Use for authentication systems, third-party integrations, service-to-service communication, or encountering token management, security headers, auth flow errors.

2w

v3.0.0

[View api-authentication](https://www.claudepluginhub.com/plugins/secondsky-api-authentication-plugins-api-authentication-2)

## api-changelog-versioning

99

Creates comprehensive API changelogs documenting breaking changes, deprecations, and migration strategies for API consumers. Use when managing API versions, communicating breaking changes, or creating upgrade guides.

2w

v3.0.0

[View api-changelog-versioning](https://www.claudepluginhub.com/plugins/secondsky-api-changelog-versioning-plugins-api-changelog-versioning-2)

## api-contract-testing

99

Verifies API contracts between services using consumer-driven contracts, schema validation, and tools like Pact. Use when testing microservices communication, preventing breaking changes, or validating OpenAPI specifications.

2w

v3.0.0

[View api-contract-testing](https://www.claudepluginhub.com/plugins/secondsky-api-contract-testing-plugins-api-contract-testing-2)

## api-design-principles

99

Master REST and GraphQL API design principles to build intuitive, scalable, and maintainable APIs that delight developers. Use when designing new APIs, reviewing API specifications, or establishing API design standards.

2w

v3.0.0

[View api-design-principles](https://www.claudepluginhub.com/plugins/secondsky-api-design-principles-plugins-api-design-principles-2)

## api-error-handling

99

Implements standardized API error responses with proper status codes, logging, and user-friendly messages. Use when building production APIs, implementing error recovery patterns, or integrating error monitoring services.

2w

v3.0.0

[View api-error-handling](https://www.claudepluginhub.com/plugins/secondsky-api-error-handling-plugins-api-error-handling-2)

## api-filtering-sorting

99

Builds flexible API filtering and sorting systems with query parameter parsing, validation, and security. Use when implementing search endpoints, building data grids, or creating dynamic query APIs.

2w

v3.0.0

[View api-filtering-sorting](https://www.claudepluginhub.com/plugins/secondsky-api-filtering-sorting-plugins-api-filtering-sorting-2)

## api-gateway-configuration

99

Configures API gateways for routing, authentication, rate limiting, and request transformation in microservice architectures. Use when setting up Kong, Nginx, AWS API Gateway, or Traefik for centralized API management.

2w

v3.0.0

[View api-gateway-configuration](https://www.claudepluginhub.com/plugins/secondsky-api-gateway-configuration-plugins-api-gateway-configuration-2)

## api-pagination

99

Implements efficient API pagination using offset, cursor, and keyset strategies for large datasets. Use when building paginated endpoints, implementing infinite scroll, or optimizing database queries for collections.

2w

v3.0.0

[View api-pagination](https://www.claudepluginhub.com/plugins/secondsky-api-pagination-plugins-api-pagination-2)

## api-rate-limiting

99

Implements API rate limiting using token bucket, sliding window, and Redis-based algorithms to protect against abuse. Use when securing public APIs, implementing tiered access, or preventing denial-of-service attacks.

2w

v3.0.0

[View api-rate-limiting](https://www.claudepluginhub.com/plugins/secondsky-api-rate-limiting-plugins-api-rate-limiting-2)

## api-reference-documentation

99

Creates professional API documentation using OpenAPI specifications with endpoints, authentication, and interactive examples. Use when documenting REST APIs, creating SDK references, or building developer portals.

2w

v3.0.0

[View api-reference-documentation](https://www.claudepluginhub.com/plugins/secondsky-api-reference-documentation-plugins-api-reference-documentation-2)

## api-response-optimization

99

Optimizes API performance through payload reduction, caching strategies, and compression techniques. Use when improving API response times, reducing bandwidth usage, or implementing efficient caching.

2w

v3.0.0

[View api-response-optimization](https://www.claudepluginhub.com/plugins/secondsky-api-response-optimization-plugins-api-response-optimization-2)

## api-security-hardening

99

REST API security hardening with authentication, rate limiting, input validation, security headers. Use for production APIs, security audits, defense-in-depth, or encountering vulnerabilities, injection attacks, CORS issues.

2w

v3.0.0

[View api-security-hardening](https://www.claudepluginhub.com/plugins/secondsky-api-security-hardening-plugins-api-security-hardening-2)

## api-testing

99

HTTP API testing for TypeScript (Supertest) and Python (httpx, pytest). Test REST APIs, GraphQL, request/response validation, authentication, and error handling.

2w

v3.0.0

[View api-testing](https://www.claudepluginhub.com/plugins/secondsky-api-testing-plugins-api-testing-2)

## api-versioning-strategy

99

Implements API versioning using URL paths, headers, or query parameters with backward compatibility and deprecation strategies. Use when managing multiple API versions, planning breaking changes, or designing migration paths.

2w

v3.0.0

[View api-versioning-strategy](https://www.claudepluginhub.com/plugins/secondsky-api-versioning-strategy-plugins-api-versioning-strategy-2)

## app-store-deployment

99

Publishes mobile applications to iOS App Store and Google Play with code signing, versioning, and CI/CD automation. Use when preparing app releases, configuring signing certificates, or setting up automated deployment pipelines.

2w

v3.0.0

[View app-store-deployment](https://www.claudepluginhub.com/plugins/secondsky-app-store-deployment-plugins-app-store-deployment-2)

## architecture-patterns

99

·

1

Implement proven backend architecture patterns including Clean Architecture, Hexagonal Architecture, and Domain-Driven Design. Use when architecting complex backend systems or refactoring existing applications for better maintainability.

2w

v3.0.0

[View architecture-patterns](https://www.claudepluginhub.com/plugins/secondsky-architecture-patterns-plugins-architecture-patterns-2)

## auto-animate

99

AutoAnimate (@formkit/auto-animate) zero-config animations for React. Use for list transitions, accordions, toasts, or encountering SSR errors, animation libraries complexity.

3mo

v3.0.0

[View auto-animate](https://www.claudepluginhub.com/plugins/secondsky-auto-animate-plugins-auto-animate-2)

## base-ui-react

99

MUI Base UI unstyled React components with Floating UI. Use for accessible components, Radix UI migration, render props API, or encountering positioning, popup, v1.0 beta issues.

3mo

v3.0.0

[View base-ui-react](https://www.claudepluginhub.com/plugins/secondsky-base-ui-react-plugins-base-ui-react-2)

## better-auth

99

Skill for integrating Better Auth - comprehensive TypeScript authentication framework for Cloudflare D1, Next.js, Nuxt, and 15+ frameworks. Use when adding auth, encountering D1 adapter errors, or implementing OAuth/2FA/RBAC features.

2w

v3.0.0

[View better-auth](https://www.claudepluginhub.com/plugins/secondsky-better-auth-plugins-better-auth-2)

## better-chatbot

99

better-chatbot project conventions and standards. Use for contributing code, following three-tier tool system (MCP/Workflow/Default), or encountering server action validators, repository patterns, component design errors.

3mo

v3.0.0

[View better-chatbot](https://www.claudepluginhub.com/plugins/secondsky-better-chatbot-plugins-better-chatbot-2)

## better-chatbot-patterns

99

Reusable better-chatbot patterns for custom deployments. Use for server action validators, tool abstraction, multi-AI providers, or encountering auth validation, FormData parsing, workflow execution errors.

3mo

v3.0.0

[View better-chatbot-patterns](https://www.claudepluginhub.com/plugins/secondsky-better-chatbot-patterns-plugins-better-chatbot-patterns-2)

## bun

99

·

2

Comprehensive Bun runtime toolkit covering runtime, package manager, bundler, testing, HTTP servers, WebSockets, databases, framework integrations (Hono, Next.js, Nuxt, TanStack Start, SvelteKit), deployment, and Node.js compatibility.

2w

v3.0.0

[View bun](https://www.claudepluginhub.com/plugins/secondsky-bun-plugins-bun-2)

## chrome-devtools

99

Browser automation with Puppeteer CLI scripts. Use for screenshots, performance analysis, network monitoring, web scraping, form automation, or encountering JavaScript debugging, browser automation errors.

3mo

v3.0.0

[View chrome-devtools](https://www.claudepluginhub.com/plugins/secondsky-chrome-devtools-plugins-chrome-devtools-2)

## claude-agent-sdk

99

Anthropic Claude Agent SDK for autonomous agents and multi-step workflows. Use for subagents, tool orchestration, MCP servers, or encountering CLI not found, context length exceeded errors.

3mo

v3.0.0

[View claude-agent-sdk](https://www.claudepluginhub.com/plugins/secondsky-claude-agent-sdk-plugins-claude-agent-sdk-2)

## claude-api

99

Anthropic Messages API (Claude API) for integrations, streaming, prompt caching, tool use, vision. Use for chatbots, assistants, or encountering rate limits, 429 errors.

2mo

v3.0.0

[View claude-api](https://www.claudepluginhub.com/plugins/secondsky-claude-api-plugins-claude-api-2)

## claude-code-bash-patterns

99

Claude Code Bash tool patterns with hooks, automation, git workflows. Use for PreToolUse hooks, command chaining, CLI orchestration, custom commands, or encountering bash permissions, command failures, security guards, hook configurations.

2mo

v3.0.0

[View claude-code-bash-patterns](https://www.claudepluginhub.com/plugins/secondsky-claude-code-bash-patterns-plugins-claude-code-bash-patterns-2)

## claude-hook-writer

99

Expert guidance for writing secure, reliable, and performant Claude Code hooks - validates design decisions, enforces best practices, and prevents common pitfalls. Use when creating, reviewing, or debugging Claude Code hooks.

2w

v3.0.0

[View claude-hook-writer](https://www.claudepluginhub.com/plugins/secondsky-claude-hook-writer-plugins-claude-hook-writer-2)

## cloudflare-agents

99

Build AI agents on Cloudflare Workers with MCP integration, tool use, and LLM providers.

3mo

v3.0.0

[View cloudflare-agents](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-agents-plugins-cloudflare-agents-2)

## cloudflare-browser-rendering

99

Cloudflare Browser Rendering with Puppeteer/Playwright. Use for screenshots, PDFs, web scraping, or encountering rendering errors, timeout issues, memory exceeded.

3mo

v3.0.0

[View cloudflare-browser-rendering](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-browser-rendering-plugins-cloudflare-browser-rendering-2)

## cloudflare-cron-triggers

99

Cloudflare Cron Triggers for scheduled Workers execution. Use for periodic tasks, scheduled jobs, or encountering handler not found, invalid cron expression, timezone errors.

3mo

v3.0.0

[View cloudflare-cron-triggers](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-cron-triggers-plugins-cloudflare-cron-triggers-2)

## cloudflare-d1

99

Cloudflare D1 serverless SQLite on edge. Use for databases, migrations, bindings, or encountering D1\_ERROR, statement too long, too many requests queued errors.

2w

v3.0.0

[View cloudflare-d1](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-d1-plugins-cloudflare-d1-2)

## cloudflare-durable-objects

99

Cloudflare Durable Objects for stateful coordination and real-time apps. Use for chat, multiplayer games, WebSocket hibernation, or encountering class export, migration, alarm errors.

2w

v3.0.0

[View cloudflare-durable-objects](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-durable-objects-plugins-cloudflare-durable-objects-2)

## cloudflare-email-routing

99

Cloudflare Email Routing for receiving/sending emails via Workers. Use for email workers, forwarding, allowlists, or encountering Email Trigger errors, worker call failures, SPF issues.

3mo

v3.0.0

[View cloudflare-email-routing](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-email-routing-plugins-cloudflare-email-routing-2)

## cloudflare-hyperdrive

99

Cloudflare Hyperdrive for Workers-to-database connections with pooling and caching. Use for PostgreSQL/MySQL, Drizzle/Prisma, or encountering pool errors, TLS issues, connection refused.

3mo

v3.0.0

[View cloudflare-hyperdrive](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-hyperdrive-plugins-cloudflare-hyperdrive-2)

## cloudflare-images

99

·

1

This skill should be used when the user asks to "upload images to Cloudflare", "implement direct creator upload", "configure image transformations", "optimize WebP/AVIF", "create image variants", "generate signed URLs", "add image watermarks", "integrate with Next.js/Remix", "configure webhooks", "debug CORS errors", "troubleshoot error 5408/9401-9413", or "build responsive images with Cloudflare Images API".

2w

v3.0.0

[View cloudflare-images](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-images-plugins-cloudflare-images-2)

## cloudflare-kv

99

Cloudflare Workers KV global key-value storage. Use for namespaces, caching, TTL, or encountering KV\_ERROR, 429 rate limits, consistency issues.

2w

v3.0.0

[View cloudflare-kv](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-kv-plugins-cloudflare-kv-2)

## cloudflare-manager

99

Comprehensive Cloudflare account management for deploying Workers, KV Storage, R2, Pages, DNS, and Routes. Use when deploying cloudflare services, managing worker containers, configuring KV/R2 storage, or setting up DNS/routing. Requires CLOUDFLARE\_API\_KEY in .env and Bun runtime with dependencies installed.

3mo

v3.0.0

[View cloudflare-manager](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-manager-plugins-cloudflare-manager-2)

## cloudflare-mcp-server

99

Build MCP (Model Context Protocol) servers on Cloudflare Workers with tools, resources, and prompts.

4w

v3.0.0

[View cloudflare-mcp-server](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-mcp-server-plugins-cloudflare-mcp-server-2)

## cloudflare-nextjs

99

Deploy Next.js to Cloudflare Workers via OpenNext adapter. Use for SSR, ISR, App/Pages Router, or encountering worker size limits, runtime compatibility, connection scoping errors.

4w

v3.0.0

[View cloudflare-nextjs](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-nextjs-plugins-cloudflare-nextjs-2)

## cloudflare-queues

99

·

2

This skill should be used when the user asks to "set up Cloudflare Queues", "create a message queue", "implement queue consumer", "process background jobs", "configure queue retry logic", "publish messages to queue", "implement dead letter queue", or encountering "queue timeout", "message retry", "throughput exceeded", "queue backlog" errors.

2w

v3.0.0

[View cloudflare-queues](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-queues-plugins-cloudflare-queues-2)

## cloudflare-r2

99

Cloudflare R2 S3-compatible object storage with SQL, Iceberg, event notifications, and automation. Use for buckets, uploads, CORS, presigned URLs, large files, S3 migration, analytics, or encountering R2\_ERROR, CORS failures, multipart issues.

2w

v3.0.0

[View cloudflare-r2](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-r2-plugins-cloudflare-r2-2)

## cloudflare-sandbox

99

Cloudflare Sandboxes SDK for secure code execution in Linux containers at edge. Use for untrusted code, Python/Node.js scripts, AI code interpreters, git operations.

3mo

v3.0.0

[View cloudflare-sandbox](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-sandbox-plugins-cloudflare-sandbox-2)

## cloudflare-turnstile

99

Cloudflare Turnstile CAPTCHA-alternative bot protection. Use for forms, login security, API protection, or encountering CSP errors, token validation failures, error codes 100\*/300\*/600\*.

2w

v3.0.0

[View cloudflare-turnstile](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-turnstile-plugins-cloudflare-turnstile-2)

## cloudflare-vectorize

99

Cloudflare Vectorize vector database for semantic search and RAG. Use for vector indexes, embeddings, similarity search, or encountering dimension mismatches, filter errors.

3mo

v3.0.0

[View cloudflare-vectorize](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-vectorize-plugins-cloudflare-vectorize-2)

## cloudflare-workers

99

Comprehensive Cloudflare Workers platform guide covering runtime APIs, testing (Vitest), CI/CD, observability, framework integration, performance, security, and migration. Use for Workers development, deployment, debugging, or optimization.

2w

v3.0.0

[View cloudflare-workers](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-workers-plugins-cloudflare-workers-2)

## cloudflare-workers-ai

99

Cloudflare Workers AI for serverless GPU inference. Use for LLMs, text/image generation, embeddings, or encountering AI\_ERROR, rate limits, token exceeded errors.

3mo

v3.0.0

[View cloudflare-workers-ai](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-workers-ai-plugins-cloudflare-workers-ai-2)

## cloudflare-workflows

99

Cloudflare Workflows for durable long-running execution. Use for multi-step workflows, retries, state persistence, or encountering NonRetryableError, execution failed errors.

2w

v3.0.0

[View cloudflare-workflows](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-workflows-plugins-cloudflare-workflows-2)

## cloudflare-zero-trust-access

99

Cloudflare Zero Trust Access authentication for Workers. Use for JWT validation, service tokens, CORS, or encountering preflight blocking, cache race conditions, missing JWT headers.

3mo

v3.0.0

[View cloudflare-zero-trust-access](https://www.claudepluginhub.com/plugins/secondsky-cloudflare-zero-trust-access-plugins-cloudflare-zero-trust-access-2)

## code-review

99

Code review practices with technical rigor and verification gates. Use for receiving feedback, requesting code-reviewer subagent reviews, or preventing false completion claims in pull requests.

2w

v3.0.0

[View code-review](https://www.claudepluginhub.com/plugins/secondsky-code-review-plugins-code-review-2)

## content-collections

99

Content Collections TypeScript-first build tool for Markdown/MDX content. Use for blogs, docs, content sites with Vite + React, MDX components, type-safe Zod schemas, Contentlayer migration, or encountering TypeScript import errors, path alias issues, collection validation errors.

2w

v3.0.0

[View content-collections](https://www.claudepluginhub.com/plugins/secondsky-content-collections-plugins-content-collections-2)

## csrf-protection

99

Implements CSRF protection using synchronizer tokens, double-submit cookies, and SameSite attributes. Use when securing web forms, protecting state-changing endpoints, or implementing defense-in-depth authentication.

2w

v3.0.0

[View csrf-protection](https://www.claudepluginhub.com/plugins/secondsky-csrf-protection-plugins-csrf-protection-2)

## database-schema-design

99

Database schema design for PostgreSQL/MySQL with normalization, relationships, constraints. Use for new databases, schema reviews, migrations, or encountering missing PKs/FKs, wrong data types, premature denormalization, EAV anti-pattern.

2w

v3.0.0

[View database-schema-design](https://www.claudepluginhub.com/plugins/secondsky-database-schema-design-plugins-database-schema-design-2)

## database-sharding

99

Database sharding for PostgreSQL/MySQL with hash/range/directory strategies. Use for horizontal scaling, multi-tenant isolation, billions of records, or encountering wrong shard keys, hotspots, cross-shard transactions, rebalancing issues.

2w

v3.0.0

[View database-sharding](https://www.claudepluginhub.com/plugins/secondsky-database-sharding-plugins-database-sharding-2)

## defense-in-depth-validation

99

Validate at every layer data passes through to make bugs impossible. Use when invalid data causes failures deep in execution, requiring validation at multiple system layers.

2w

v3.0.0

[View defense-in-depth-validation](https://www.claudepluginhub.com/plugins/secondsky-defense-in-depth-validation-plugins-defense-in-depth-validation-2)

## dependency-upgrade

99

Secure dependency upgrades with supply chain protection, cooldown periods, post-install script hardening, lockfile validation, and staged rollout across npm, Bun, pnpm, and Yarn. Use when upgrading dependencies, configuring security policies, or preventing supply chain attacks.

2w

v3.0.0

[View dependency-upgrade](https://www.claudepluginhub.com/plugins/secondsky-dependency-upgrade-plugins-dependency-upgrade-2)

## design-review

99

7-phase frontend design review with accessibility (WCAG 2.1 AA), responsive testing, visual polish. Use for PR reviews, UI audits, or encountering contrast issues, broken layouts, accessibility violations, inconsistent spacing, missing focus states.

3mo

v3.0.0

[View design-review](https://www.claudepluginhub.com/plugins/secondsky-design-review-plugins-design-review-2)

## design-system-creation

99

Creates comprehensive design systems with typography, colors, components, and documentation for consistent UI development. Use when establishing design standards, building component libraries, or ensuring cross-team consistency.

2w

v3.0.0

[View design-system-creation](https://www.claudepluginhub.com/plugins/secondsky-design-system-creation-plugins-design-system-creation-2)

## drizzle-orm-d1

99

·

3

Type-safe ORM for Cloudflare D1 databases using Drizzle. Use when: building D1 database schemas, writing type-safe SQL queries, managing migrations with Drizzle Kit, defining table relations, implementing prepared statements, using D1 batch API, or encountering D1\_ERROR, transaction errors, foreign key constraint failures, or schema inference issues.

2w

v3.0.0

[View drizzle-orm-d1](https://www.claudepluginhub.com/plugins/secondsky-drizzle-orm-d1-plugins-drizzle-orm-d1-2)

## elevenlabs-agents

99

ElevenLabs Agents Platform for AI voice agents (React/JS/Native/Swift). Use for voice AI, RAG, tools, or encountering package deprecation, audio cutoff, CSP violations, webhook auth failures.

3mo

v3.0.0

[View elevenlabs-agents](https://www.claudepluginhub.com/plugins/secondsky-elevenlabs-agents-plugins-elevenlabs-agents-2)

## fastmcp

99

FastMCP Python framework for MCP servers with tools, resources, storage backends (memory/disk/Redis/DynamoDB). Use for Claude tool exposure, OAuth Proxy, cloud deployment, or encountering storage, lifespan, middleware, circular import, async errors.

3mo

v3.0.0

[View fastmcp](https://www.claudepluginhub.com/plugins/secondsky-fastmcp-plugins-fastmcp-2)

## feature-dev

99

·

5

Automate 7-phase feature development with specialized agents (code-explorer, code-architect, code-reviewer). Use for multi-file features, architectural decisions, or encountering ambiguous requirements, integration patterns, design approach errors.

3mo

v3.0.0

[View feature-dev](https://www.claudepluginhub.com/plugins/secondsky-feature-dev-plugins-feature-dev-2)

## firecrawl-scraper

99

Firecrawl v2.5 API for web scraping/crawling to LLM-ready markdown. Use for site extraction, dynamic content, or encountering JavaScript rendering, bot detection, content loading errors.

3mo

v3.0.0

[View firecrawl-scraper](https://www.claudepluginhub.com/plugins/secondsky-firecrawl-scraper-plugins-firecrawl-scraper-2)

## frontend-design

99

·

6

Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, or applications. Generates creative, polished code that avoids generic AI aesthetics.

3mo

v3.0.0

[View frontend-design](https://www.claudepluginhub.com/plugins/secondsky-frontend-design-plugins-frontend-design-2)

## gemini-cli

99

·

1

Google Gemini CLI for second opinions, architectural advice, code reviews, security audits. Leverage 1M+ context for comprehensive codebase analysis via command-line tool.

3mo

v3.0.0

[View gemini-cli](https://www.claudepluginhub.com/plugins/secondsky-gemini-cli-plugins-gemini-cli-2)

## github-project-automation

99

GitHub repository automation (CI/CD, issue templates, Dependabot, CodeQL). Use for project setup, Actions workflows, security scanning, or encountering YAML syntax, workflow configuration, template structure errors.

3mo

v3.0.0

[View github-project-automation](https://www.claudepluginhub.com/plugins/secondsky-github-project-automation-plugins-github-project-automation-2)

## google-gemini-api

99

Google Gemini API with @google/genai SDK. Use for multimodal AI, thinking mode, function calling, or encountering SDK deprecation warnings, context errors, multimodal format errors.

3mo

v3.0.0

[View google-gemini-api](https://www.claudepluginhub.com/plugins/secondsky-google-gemini-api-plugins-google-gemini-api-2)

## google-gemini-embeddings

99

Google Gemini embeddings API (gemini-embedding-001) for RAG and semantic search. Use for vector search, Vectorize integration, or encountering dimension mismatches, rate limits, text truncation.

3mo

v3.0.0

[View google-gemini-embeddings](https://www.claudepluginhub.com/plugins/secondsky-google-gemini-embeddings-plugins-google-gemini-embeddings-2)

## google-gemini-file-search

99

Google Gemini File Search for managed RAG with 100+ file formats. Use for document Q&A, knowledge bases, or encountering immutability errors, quota issues, polling failures. Supports Gemini 3 Pro/Flash (Gemini 2.5 legacy).

3mo

v3.0.0

[View google-gemini-file-search](https://www.claudepluginhub.com/plugins/secondsky-google-gemini-file-search-plugins-google-gemini-file-search-2)

## graphql-implementation

99

Builds GraphQL APIs with schema design, resolvers, error handling, and performance optimization using Apollo or Graphene. Use when creating flexible query APIs, migrating from REST, or implementing real-time subscriptions.

2w

v3.0.0

[View graphql-implementation](https://www.claudepluginhub.com/plugins/secondsky-graphql-implementation-plugins-graphql-implementation-2)

## health-check-endpoints

99

Health check endpoints for liveness, readiness, dependency monitoring. Use for Kubernetes, load balancers, auto-scaling, or encountering probe failures, startup delays, dependency checks, timeout configuration errors.

2w

v3.0.0

[View health-check-endpoints](https://www.claudepluginhub.com/plugins/secondsky-health-check-endpoints-plugins-health-check-endpoints-2)

## hono-routing

99

Type-safe Hono APIs with routing, middleware, RPC. Use for request validation, Zod/Valibot validators, or encountering middleware type inference, validation hook, RPC errors.

3mo

v3.0.0

[View hono-routing](https://www.claudepluginhub.com/plugins/secondsky-hono-routing-plugins-hono-routing-2)

## hugo

99

Hugo static site generator with Tailwind v4, headless CMS (Sveltia/Tina), Cloudflare deployment. Use for blogs, docs sites, or encountering theme installation, frontmatter, baseURL errors.

3mo

v3.0.0

[View hugo](https://www.claudepluginhub.com/plugins/secondsky-hugo-plugins-hugo-2)

## idempotency-handling

99

Idempotent API operations with idempotency keys, Redis caching, DB constraints. Use for payment systems, webhook retries, safe retries, or encountering duplicate processing, race conditions, key expiry errors.

2w

v3.0.0

[View idempotency-handling](https://www.claudepluginhub.com/plugins/secondsky-idempotency-handling-plugins-idempotency-handling-2)

## image-optimization

99

Optimizes images for web performance using modern formats, responsive techniques, and lazy loading strategies. Use when improving page load times, implementing responsive images, or preparing assets for production deployment.

3mo

v3.0.0

[View image-optimization](https://www.claudepluginhub.com/plugins/secondsky-image-optimization-plugins-image-optimization-2)

## inspira-ui

99

120+ Vue/Nuxt animated components with TailwindCSS v4, motion-v, GSAP, Three.js. Use for hero sections, 3D effects, interactive backgrounds, or encountering setup, CSS variables, motion-v integration errors.

2w

v3.0.0

[View inspira-ui](https://www.claudepluginhub.com/plugins/secondsky-inspira-ui-plugins-inspira-ui-2)

## interaction-design

99

·

2

Creates intuitive user experiences through feedback patterns, microinteractions, and accessible interaction design. Use when designing loading states, error handling UX, animation guidelines, or touch interactions.

3mo

v3.0.0

[View interaction-design](https://www.claudepluginhub.com/plugins/secondsky-interaction-design-plugins-interaction-design-2)

## internationalization-i18n

99

·

2

Implements multi-language support using i18next, gettext, or Intl API with translation workflows and RTL support. Use when building multilingual applications, handling date/currency formatting, or supporting right-to-left languages.

2w

v3.0.0

[View internationalization-i18n](https://www.claudepluginhub.com/plugins/secondsky-internationalization-i18n-plugins-internationalization-i18n-2)

## jest-generator

99

·

2

Generate Jest unit tests for JavaScript/TypeScript with mocking, coverage. Use for JS/TS modules, React components, test generation, or encountering missing coverage, improper mocking, test structure errors.

2w

v3.0.0

[View jest-generator](https://www.claudepluginhub.com/plugins/secondsky-jest-generator-plugins-jest-generator-2)

## kpi-dashboard-design

99

·

1

Designs effective KPI dashboards with proper metric selection, visual hierarchy, and data visualization best practices. Use when building executive dashboards, creating analytics views, or presenting business metrics.

3mo

v3.0.0

[View kpi-dashboard-design](https://www.claudepluginhub.com/plugins/secondsky-kpi-dashboard-design-plugins-kpi-dashboard-design-2)

## logging-best-practices

99

Structured logging with proper levels, context, PII handling, centralized aggregation. Use for application logging, log management integration, distributed tracing, or encountering log bloat, PII exposure, missing context errors.

2w

v3.0.0

[View logging-best-practices](https://www.claudepluginhub.com/plugins/secondsky-logging-best-practices-plugins-logging-best-practices-2)

## maz-ui

99

Maz-UI v4 - Modern Vue & Nuxt component library with 50+ standalone components, composables, directives, theming, i18n, and SSR support.

2w

v3.0.0

[View maz-ui](https://www.claudepluginhub.com/plugins/secondsky-maz-ui-plugins-maz-ui-2)

## mcp-dynamic-orchestrator

99

Dynamic MCP server discovery and code-mode execution via central registry. Use for multiple MCP integrations, tool discovery, progressive disclosure, or encountering MCP context bloat, changing server sets, large tool sets.

3mo

v3.0.0

[View mcp-dynamic-orchestrator](https://www.claudepluginhub.com/plugins/secondsky-mcp-dynamic-orchestrator-plugins-mcp-dynamic-orchestrator-2)

## mcp-management

99

Manage MCP servers - discover, analyze, execute tools/prompts/resources. Use for MCP integrations, capability discovery, tool filtering, programmatic execution, or encountering context bloat, server configuration, tool execution errors.

2w

v3.0.0

[View mcp-management](https://www.claudepluginhub.com/plugins/secondsky-mcp-management-plugins-mcp-management-2)

## microservices-patterns

99

Design microservices architectures with service boundaries, event-driven communication, and resilience patterns. Use when building distributed systems, decomposing monoliths, or implementing microservices.

2w

v3.0.0

[View microservices-patterns](https://www.claudepluginhub.com/plugins/secondsky-microservices-patterns-plugins-microservices-patterns-2)

## ml-model-training

99

Train ML models with scikit-learn, PyTorch, TensorFlow. Use for classification/regression, neural networks, hyperparameter tuning, or encountering overfitting, underfitting, convergence issues.

2w

v3.0.0

[View ml-model-training](https://www.claudepluginhub.com/plugins/secondsky-ml-model-training-plugins-ml-model-training-2)

## ml-pipeline-automation

99

Automate ML workflows with Airflow, Kubeflow, MLflow. Use for reproducible pipelines, retraining schedules, MLOps, or encountering task failures, dependency errors, experiment tracking issues.

2w

v3.0.0

[View ml-pipeline-automation](https://www.claudepluginhub.com/plugins/secondsky-ml-pipeline-automation-plugins-ml-pipeline-automation-2)

## mobile-app-debugging

99

Mobile app debugging for iOS, Android, cross-platform frameworks. Use for crashes, memory leaks, performance issues, network problems, or encountering Xcode instruments, Android Profiler, React Native debugger, native bridge errors.

2w

v3.0.0

[View mobile-app-debugging](https://www.claudepluginhub.com/plugins/secondsky-mobile-app-debugging-plugins-mobile-app-debugging-2)

## mobile-app-testing

99

Mobile app testing with unit tests, UI automation, performance testing. Use for test infrastructure, E2E tests, testing standards, or encountering test framework setup, device farms, flaky tests, platform-specific test errors.

2w

v3.0.0

[View mobile-app-testing](https://www.claudepluginhub.com/plugins/secondsky-mobile-app-testing-plugins-mobile-app-testing-2)

## mobile-first-design

99

Designs responsive interfaces starting from mobile screens with progressive enhancement for larger devices. Use when building responsive websites, optimizing for mobile users, or implementing adaptive layouts.

2w

v3.0.0

[View mobile-first-design](https://www.claudepluginhub.com/plugins/secondsky-mobile-first-design-plugins-mobile-first-design-2)

## mobile-offline-support

99

Offline-first mobile apps with local storage, sync queues, conflict resolution. Use for offline functionality, data sync, connectivity handling, or encountering sync conflicts, queue management, storage limits, network transition errors.

2w

v3.0.0

[View mobile-offline-support](https://www.claudepluginhub.com/plugins/secondsky-mobile-offline-support-plugins-mobile-offline-support-2)

## model-deployment

99

Deploy ML models with FastAPI, Docker, Kubernetes. Use for serving predictions, containerization, monitoring, drift detection, or encountering latency issues, health check failures, version conflicts.

2w

v3.0.0

[View model-deployment](https://www.claudepluginhub.com/plugins/secondsky-model-deployment-plugins-model-deployment-2)

## motion

99

·

2

Motion (Framer Motion) React animation library. Use for drag-and-drop, scroll animations, gestures, SVG morphing, or encountering bundle size, complex transitions, spring physics errors.

3mo

v3.0.0

[View motion](https://www.claudepluginhub.com/plugins/secondsky-motion-plugins-motion-2)

## multi-ai-consultant

99

Consult external AIs (Gemini 2.5 Pro, OpenAI Codex, Claude) for second opinions. Use for debugging failures, architectural decisions, security validation, or need fresh perspective with synthesis.

2w

v3.0.0

[View multi-ai-consultant](https://www.claudepluginhub.com/plugins/secondsky-multi-ai-consultant-plugins-multi-ai-consultant-2)

## mutation-testing

99

Validate test effectiveness with mutation testing using Stryker (TypeScript/JavaScript) and mutmut (Python). Find weak tests that pass despite code mutations. Use to improve test quality.

2w

v3.0.0

[View mutation-testing](https://www.claudepluginhub.com/plugins/secondsky-mutation-testing-plugins-mutation-testing-2)

## nano-banana-prompts

99

·

1

Generate optimized prompts for Gemini 2.5 Flash Image (Nano Banana). Use for image generation, crafting photo prompts, art styles, or multi-turn editing workflows with best practices.

3mo

v3.0.0

[View nano-banana-prompts](https://www.claudepluginhub.com/plugins/secondsky-nano-banana-prompts-plugins-nano-banana-prompts-2)

## neon-vercel-postgres

99

Neon + Vercel serverless Postgres for edge and serverless environments. Use for Cloudflare Workers, Vercel Edge, Next.js apps with HTTP/WebSocket connections, database branching (git-like), Drizzle/Prisma ORM integration, migrations, PITR backups, or encountering connection pool exhausted errors, TCP connection issues, SSL config problems.

2w

v3.0.0

[View neon-vercel-postgres](https://www.claudepluginhub.com/plugins/secondsky-neon-vercel-postgres-plugins-neon-vercel-postgres-2)

## nextjs

99

Next.js 16 with App Router, Server Components, Server Actions, Cache Components. Use for React 19.2 apps, SSR, or encountering async params, proxy.ts migration, use cache errors.

3mo

v3.0.0

[View nextjs](https://www.claudepluginhub.com/plugins/secondsky-nextjs-plugins-nextjs-2)

## nuxt-content

99

Nuxt Content v3 Git-backed CMS for Markdown/MDC content sites. Use for blogs, docs, content-driven apps with type-safe queries, schema validation (Zod/Valibot), full-text search, navigation utilities. Supports Nuxt Studio production editing, Cloudflare D1/Pages deployment, Vercel deployment, SQL storage, MDC components, content collections.

2w

v3.0.0

[View nuxt-content](https://www.claudepluginhub.com/plugins/secondsky-nuxt-content-plugins-nuxt-content-2)

## nuxt-seo

99

Comprehensive guide for all 8 Nuxt SEO modules plus Pro modules. Use when building SEO-optimized Nuxt applications, implementing robots.txt/sitemaps, generating OG images, adding Schema.org data, managing meta tags, checking links, or encountering sitemap, robots.txt, OG image, schema validation, meta tag, canonical URL, or i18n SEO errors.

2w

v3.0.0

[View nuxt-seo](https://www.claudepluginhub.com/plugins/secondsky-nuxt-seo-plugins-nuxt-seo-2)

## nuxt-studio

99

Visual CMS for Nuxt Content with Cloudflare deployment. Use when setting up Nuxt Studio, configuring OAuth authentication, deploying to Cloudflare Pages/Workers with subdomain routing, or troubleshooting Studio integration.

2w

v3.0.0

[View nuxt-studio](https://www.claudepluginhub.com/plugins/secondsky-nuxt-studio-plugins-nuxt-studio-2)

## nuxt-ui-v4

99

·

1

Nuxt UI v4 with 125+ accessible components, Tailwind v4, Reka UI, AI chat integration with reasoning and tool calling. Use for dashboards, forms, overlays, editors, page layouts, or encountering theming, composable, TypeScript errors.

2w

v3.0.0

[View nuxt-ui-v4](https://www.claudepluginhub.com/plugins/secondsky-nuxt-ui-v4-plugins-nuxt-ui-v4-2)

## nuxt-v4

99

Comprehensive Nuxt 4 development with 4 focused skills (core, data, server, production), 3 diagnostic agents (debugger, migration, performance), and interactive setup wizard. Use when: building Nuxt 4 applications, implementing SSR patterns, creating composables, server routes, data fetching, state management, debugging hydration issues, migrating from Nuxt 3, optimizing performance, deploying to Cloudflare/Vercel/Netlify, or setting up testing with Vitest.

2w

v3.0.0

[View nuxt-v4](https://www.claudepluginhub.com/plugins/secondsky-nuxt-v4-plugins-nuxt-v4-2)

## nuxt-v5

99

·

1

Comprehensive Nuxt 5 development with 4 focused skills (core, data, server, production), 3 diagnostic agents (debugger, migration, performance), and interactive setup wizard. Use when: building Nuxt 5 applications, implementing SSR patterns, creating composables, server routes, data fetching, state management, debugging hydration issues, migrating from Nuxt 4, optimizing performance, deploying to Cloudflare/Vercel/Netlify, or setting up testing with Vitest.

2w

v3.0.0

[View nuxt-v5](https://www.claudepluginhub.com/plugins/secondsky-nuxt-v5-plugins-nuxt-v5)

## oauth-implementation

99

OAuth 2.0 and OpenID Connect authentication with secure flows. Use for third-party integrations, SSO systems, token-based API access, or encountering authorization code flow, PKCE, token refresh, scope management errors.

2w

v3.0.0

[View oauth-implementation](https://www.claudepluginhub.com/plugins/secondsky-oauth-implementation-plugins-oauth-implementation-2)

## openai-agents

99

OpenAI Agents SDK for JavaScript/TypeScript (text + voice agents). Use for multi-agent workflows, tools, guardrails, or encountering Zod errors, MCP failures, infinite loops, tool call issues.

3mo

v3.0.0

[View openai-agents](https://www.claudepluginhub.com/plugins/secondsky-openai-agents-plugins-openai-agents-2)

## openai-api

99

Complete guide for OpenAI APIs: Chat Completions (GPT-5.2, GPT-4o), Embeddings, Images (GPT-Image-1.5), Audio (Whisper + TTS + Transcribe), Moderation. Includes Node.js SDK and fetch approaches.

3mo

v3.0.0

[View openai-api](https://www.claudepluginhub.com/plugins/secondsky-openai-api-plugins-openai-api-2)

## openai-assistants

99

OpenAI Assistants API v2 for stateful chatbots with Code Interpreter, File Search, RAG. Use for threads, vector stores, or encountering active run errors, indexing delays. ⚠️ Sunset August 26, 2026.

3mo

v3.0.0

[View openai-assistants](https://www.claudepluginhub.com/plugins/secondsky-openai-assistants-plugins-openai-assistants-2)

## openai-responses

99

·

1

OpenAI Responses API for stateful agentic applications with reasoning preservation. Use for MCP integration, built-in tools, background processing, or migrating from Chat Completions.

3mo

v3.0.0

[View openai-responses](https://www.claudepluginhub.com/plugins/secondsky-openai-responses-plugins-openai-responses-2)

## payment-gateway-integration

99

Integrates payment processing with Stripe, PayPal, or Square including subscriptions, webhooks, and PCI compliance. Use when implementing checkout flows, recurring billing, or handling refunds and disputes.

2w

v3.0.0

[View payment-gateway-integration](https://www.claudepluginhub.com/plugins/secondsky-payment-gateway-integration-plugins-payment-gateway-integration-2)

## pinia-colada

99

Pinia Colada data fetching for Vue/Nuxt with useQuery, useMutation. Use for async state, query cache, SSR, or encountering invalidation, hydration, TanStack Vue Query migration errors.

3mo

v3.0.0

[View pinia-colada](https://www.claudepluginhub.com/plugins/secondsky-pinia-colada-plugins-pinia-colada-2)

## pinia-v3

99

Pinia v3 Vue state management with defineStore, getters, actions. Use for Vue 3 stores, Nuxt SSR, Vuex migration, or encountering store composition, hydration, testing errors.

3mo

v3.0.0

[View pinia-v3](https://www.claudepluginhub.com/plugins/secondsky-pinia-v3-plugins-pinia-v3-2)

## plan-interview

99

Adaptive interview-driven spec generation with quality review. Automatically adjusts depth based on plan complexity.

2w

v3.0.0

[View plan-interview](https://www.claudepluginhub.com/plugins/secondsky-plan-interview-plugins-plan-interview-2)

## playwright

99

·

4

Browser automation and E2E testing with Playwright. Auto-detects dev servers, writes clean test scripts. Test pages, fill forms, take screenshots, check responsive design, validate UX, test login flows, check links, automate any browser task. Use for cross-browser testing, visual regression, API testing, component testing in TypeScript/JavaScript and Python projects.

2w

v3.0.0

[View playwright](https://www.claudepluginhub.com/plugins/secondsky-playwright-plugins-playwright-2)

## progressive-web-app

99

Builds Progressive Web Apps with service workers, web manifest, offline support, and installation prompts. Use when creating installable web experiences, implementing offline functionality, or adding push notifications to web apps.

3mo

v3.0.0

[View progressive-web-app](https://www.claudepluginhub.com/plugins/secondsky-progressive-web-app-plugins-progressive-web-app-2)

## push-notification-setup

99

Implements push notifications across iOS, Android, and web using Firebase Cloud Messaging and native services. Use when adding notification capabilities, handling background messages, or setting up notification channels.

2w

v3.0.0

[View push-notification-setup](https://www.claudepluginhub.com/plugins/secondsky-push-notification-setup-plugins-push-notification-setup-2)

## react-best-practices

99

React and Next.js performance optimization guidelines from Vercel Engineering. Use when writing/reviewing/refactoring React code for optimal performance. Covers async patterns, bundle optimization, server/client components, re-render optimization.

2w

v3.0.0

[View react-best-practices](https://www.claudepluginhub.com/plugins/secondsky-react-best-practices-plugins-react-best-practices-2)

## react-composition-patterns

99

React composition patterns from Vercel Engineering. Use when building scalable components, avoiding boolean prop proliferation, implementing compound components, or managing component state. Covers architecture, state management, and implementation patterns.

2w

v3.0.0

[View react-composition-patterns](https://www.claudepluginhub.com/plugins/secondsky-react-composition-patterns-plugins-react-composition-patterns-2)

## react-hook-form-zod

99

Type-safe React forms with React Hook Form and Zod validation. Use for form schemas, field arrays, multi-step forms, or encountering validation errors, resolver issues, nested field problems.

3mo

v3.0.0

[View react-hook-form-zod](https://www.claudepluginhub.com/plugins/secondsky-react-hook-form-zod-plugins-react-hook-form-zod-2)

## react-native-skills

99

React Native and Expo best practices for building performant mobile apps. Use when building React Native components, optimizing list performance, implementing animations, or working with native modules.

2w

v3.0.0

[View react-native-skills](https://www.claudepluginhub.com/plugins/secondsky-react-native-skills-plugins-react-native-skills-2)

## recommendation-engine

99

Build recommendation systems with collaborative filtering, matrix factorization, hybrid approaches. Use for product recommendations, personalization, or encountering cold start, sparsity, quality evaluation issues.

2w

v3.0.0

[View recommendation-engine](https://www.claudepluginhub.com/plugins/secondsky-recommendation-engine-plugins-recommendation-engine-2)

## recommendation-system

99

Deploy production recommendation systems with feature stores, caching, A/B testing. Use for personalization APIs, low latency serving, or encountering cache invalidation, experiment tracking, quality monitoring issues.

2w

v3.0.0

[View recommendation-system](https://www.claudepluginhub.com/plugins/secondsky-recommendation-system-plugins-recommendation-system-2)

## responsive-web-design

99

Builds adaptive web interfaces using Flexbox, CSS Grid, and media queries with a mobile-first approach. Use when creating multi-device layouts, implementing flexible UI systems, or ensuring cross-browser compatibility.

2w

v3.0.0

[View responsive-web-design](https://www.claudepluginhub.com/plugins/secondsky-responsive-web-design-plugins-responsive-web-design-2)

## rest-api-design

99

·

2

Designs RESTful APIs with proper resource naming, HTTP methods, status codes, and response formats. Use when building new APIs, establishing API conventions, or designing developer-friendly interfaces.

2w

v3.0.0

[View rest-api-design](https://www.claudepluginhub.com/plugins/secondsky-rest-api-design-plugins-rest-api-design-2)

## root-cause-tracing

99

Systematically trace bugs backward through call stack to find original trigger. Use when errors occur deep in execution and you need to trace back to find the original trigger.

2w

v3.0.0

[View root-cause-tracing](https://www.claudepluginhub.com/plugins/secondsky-root-cause-tracing-plugins-root-cause-tracing-2)

## security-headers-configuration

99

Configures HTTP security headers to protect against XSS, clickjacking, and MIME sniffing attacks. Use when hardening web applications, passing security audits, or implementing Content Security Policy.

2w

v3.0.0

[View security-headers-configuration](https://www.claudepluginhub.com/plugins/secondsky-security-headers-configuration-plugins-security-headers-configuration-2)

## seo-keyword-cluster-builder

99

Groups related keywords into topic clusters and creates content hub architecture recommendations with internal linking strategies. Use when planning content strategy, organizing keyword research, or building pillar page structures.

2w

v3.0.0

[View seo-keyword-cluster-builder](https://www.claudepluginhub.com/plugins/secondsky-seo-keyword-cluster-builder-plugins-seo-keyword-cluster-builder-2)

## seo-optimizer

99

·

1

SEO optimization with keyword analysis, readability assessment, technical validation, content quality. Use for search rankings, blog posts, content audits, or encountering keyword density, readability scores, meta tags, schema markup errors.

2w

v3.0.0

[View seo-optimizer](https://www.claudepluginhub.com/plugins/secondsky-seo-optimizer-plugins-seo-optimizer-2)

## sequential-thinking

99

·

8

Systematic step-by-step reasoning with revision and branching. Use for complex problems, multi-stage analysis, design planning, problem decomposition, or encountering unclear scope, alternative approaches needed, revision requirements.

3mo

v3.0.0

[View sequential-thinking](https://www.claudepluginhub.com/plugins/secondsky-sequential-thinking-plugins-sequential-thinking-2)

## session-management

99

·

2

Implements secure session management with JWT tokens, Redis storage, refresh flows, and proper cookie configuration. Use when building authentication systems, managing user sessions, or implementing secure logout functionality.

2w

v3.0.0

[View session-management](https://www.claudepluginhub.com/plugins/secondsky-session-management-plugins-session-management-2)

## shadcn-vue

99

shadcn-vue for Vue/Nuxt with Reka UI components and Tailwind. Use for accessible UI, Auto Form, data tables, charts, or encountering component imports, dark mode, Reka UI errors.

3mo

v3.0.0

[View shadcn-vue](https://www.claudepluginhub.com/plugins/secondsky-shadcn-vue-plugins-shadcn-vue-2)

## sql-query-optimization

99

·

2

SQL query optimization for PostgreSQL/MySQL with indexing, EXPLAIN analysis. Use for slow queries, N+1 problems, missing indexes, or encountering sequential scans, OFFSET pagination, temp table spills, inefficient JOINs.

3mo

v3.0.0

[View sql-query-optimization](https://www.claudepluginhub.com/plugins/secondsky-sql-query-optimization-plugins-sql-query-optimization-2)

## supabase-postgres-best-practices

99

·

1

Postgres performance optimization and best practices from Supabase. 30 rules across 8 categories prioritized by impact.

2w

v3.0.0

[View supabase-postgres-best-practices](https://www.claudepluginhub.com/plugins/secondsky-supabase-postgres-best-practices-plugins-supabase-postgres-best-practices)

## sveltia-cms

99

Sveltia CMS Git-backed content management (Decap/Netlify CMS successor). 5x smaller bundle (300 KB), GraphQL performance, solves 260+ issues. Use for static sites (Hugo, Jekyll, 11ty, Gatsby, Astro, Next.js), blogs, docs, i18n, or encountering OAuth errors, TOML/YAML issues, CORS problems, content listing errors.

2w

v3.0.0

[View sveltia-cms](https://www.claudepluginhub.com/plugins/secondsky-sveltia-cms-plugins-sveltia-cms-2)

## swift-best-practices

99

·

2

This skill should be used when writing or reviewing Swift code for iOS or macOS projects. Apply modern Swift 6+ best practices, concurrency patterns, API design guidelines, and migration strategies. Covers async/await, actors, MainActor, Sendable, typed throws, and Swift 6 breaking changes.

2w

v3.0.0

[View swift-best-practices](https://www.claudepluginhub.com/plugins/secondsky-swift-best-practices-plugins-swift-best-practices-2)

## swift-settingskit

99

SettingsKit for SwiftUI settings interfaces (iOS, macOS, watchOS, tvOS, visionOS). Use for settings/preferences screens, searchable settings, nested navigation, @Observable/@Bindable state, or encountering settings update errors, navigation state issues.

2w

v3.0.0

[View swift-settingskit](https://www.claudepluginhub.com/plugins/secondsky-swift-settingskit-plugins-swift-settingskit-2)

## systematic-debugging

99

Four-phase debugging framework that ensures root cause investigation before attempting fixes. Never jump to solutions. Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes.

2w

v3.0.0

[View systematic-debugging](https://www.claudepluginhub.com/plugins/secondsky-systematic-debugging-plugins-systematic-debugging-2)

## tailwind-v4-shadcn

99

Production-tested setup for Tailwind CSS v4 with shadcn/ui, Vite, and React. Use when: initializing React projects with Tailwind v4, setting up shadcn/ui, implementing dark mode, debugging CSS variable issues, fixing theme switching, migrating from Tailwind v3, or encountering color/theming problems. Covers: @theme inline pattern, CSS variable architecture, dark mode with ThemeProvider, component composition, vite.config setup, common v4 gotchas, and production-tested patterns.

2w

v3.0.0

[View tailwind-v4-shadcn](https://www.claudepluginhub.com/plugins/secondsky-tailwind-v4-shadcn-plugins-tailwind-v4-shadcn-2)

## tanstack-ai

99

TanStack AI (alpha) provider-agnostic type-safe chat with streaming for OpenAI, Anthropic, Gemini, Ollama. Use for chat APIs, React/Solid frontends with useChat/ChatClient, isomorphic tools, tool approval flows, agent loops, multimodal inputs, or troubleshooting streaming and tool definitions.

2w

v3.0.0

[View tanstack-ai](https://www.claudepluginhub.com/plugins/secondsky-tanstack-ai-plugins-tanstack-ai-2)

## tanstack-query

99

TanStack Query v5 (React Query) server state management. Use for data fetching, caching, mutations, or encountering v4 migration, stale data, invalidation errors.

3mo

v3.0.0

[View tanstack-query](https://www.claudepluginhub.com/plugins/secondsky-tanstack-query-plugins-tanstack-query-2)

## tanstack-router

99

TanStack Router type-safe file-based routing for React. Use for SPAs, TanStack Query integration, Cloudflare Workers, or encountering devtools, type safety, loader, Vite bundling errors.

2w

v3.0.0

[View tanstack-router](https://www.claudepluginhub.com/plugins/secondsky-tanstack-router-plugins-tanstack-router-2)

## tanstack-start

99

·

2

TanStack Start (RC) full-stack React with server functions, SSR, Cloudflare Workers. Use for Next.js migration, edge rendering, or encountering hydration, auth, data pattern errors.

2w

v3.0.0

[View tanstack-start](https://www.claudepluginhub.com/plugins/secondsky-tanstack-start-plugins-tanstack-start-2)

## tanstack-table

99

TanStack Table v8 headless data tables with server-side features for Cloudflare Workers + D1. Use for pagination, filtering, sorting, virtualization, or encountering state management, TanStack Query coordination, URL sync errors.

2w

v3.0.0

[View tanstack-table](https://www.claudepluginhub.com/plugins/secondsky-tanstack-table-plugins-tanstack-table-2)

## technical-specification

99

Creates detailed technical specifications for software projects covering requirements, architecture, APIs, and testing strategies. Use when planning features, documenting system design, or creating architecture decision records.

2w

v3.0.0

[View technical-specification](https://www.claudepluginhub.com/plugins/secondsky-technical-specification-plugins-technical-specification-2)

## test-quality-analysis

99

Detect test smells, overmocking, flaky tests, and coverage issues. Analyze test effectiveness, maintainability, and reliability. Use when reviewing tests or improving test quality.

2w

v3.0.0

[View test-quality-analysis](https://www.claudepluginhub.com/plugins/secondsky-test-quality-analysis-plugins-test-quality-analysis-2)

## thesys-generative-ui

99

AI-powered generative UI with Thesys - create React components from natural language.

2w

v3.0.0

[View thesys-generative-ui](https://www.claudepluginhub.com/plugins/secondsky-thesys-generative-ui-plugins-thesys-generative-ui-2)

## threejs

99

·

7

Comprehensive Three.js skills for building 3D web experiences

2w

v3.0.0

[View threejs](https://www.claudepluginhub.com/plugins/secondsky-threejs-plugins-threejs)

## turborepo

99

Turborepo high-performance monorepo build system. Use for monorepo setup, build optimization, task pipelines, caching strategies, or multi-package orchestration.

2w

v3.0.0

[View turborepo](https://www.claudepluginhub.com/plugins/secondsky-turborepo-plugins-turborepo-2)

## typescript-mcp

99

MCP servers with TypeScript on Cloudflare Workers using @modelcontextprotocol/sdk. Use for API integrations, stateless tools, edge deployments, or encountering export syntax, schema validation, memory leak, CORS, auth errors.

3mo

v3.0.0

[View typescript-mcp](https://www.claudepluginhub.com/plugins/secondsky-typescript-mcp-plugins-typescript-mcp-2)

## ultracite

99

Ultracite multi-provider linting/formatting (Biome, ESLint, Oxlint). Use for v6/v7 setup, provider selection, Git hooks, MCP integration, AI hooks, migrations, or encountering configuration, type-aware linting, monorepo errors.

2w

v3.0.0

[View ultracite](https://www.claudepluginhub.com/plugins/secondsky-ultracite-plugins-ultracite-2)

## vercel-blob

99

Vercel Blob object storage with CDN for Next.js. Use for file uploads (images, PDFs, videos), presigned URLs, user-generated content, file management, or encountering BLOB\_READ\_WRITE\_TOKEN errors, file size limits, client upload token errors.

2w

v3.0.0

[View vercel-blob](https://www.claudepluginhub.com/plugins/secondsky-vercel-blob-plugins-vercel-blob-2)

## vercel-kv

99

Vercel KV (Redis-compatible key-value storage via Upstash). Use for Next.js caching, sessions, rate limiting, TTL data storage, or encountering KV\_REST\_API\_URL errors, rate limit issues, JSON serialization errors. Provides strong consistency vs eventual consistency.

2w

v3.0.0

[View vercel-kv](https://www.claudepluginhub.com/plugins/secondsky-vercel-kv-plugins-vercel-kv-2)

## verification-before-completion

99

Run verification commands and confirm output before claiming success. Use when about to claim work is complete, fixed, or passing, before committing or creating PRs.

2w

v3.0.0

[View verification-before-completion](https://www.claudepluginhub.com/plugins/secondsky-verification-before-completion-plugins-verification-before-completion-2)

## vitest-testing

99

·

1

Modern TypeScript/JavaScript testing with Vitest. Fast unit and integration tests, native ESM support, Vite-powered HMR, and comprehensive mocking. Use for testing TS/JS projects.

2w

v3.0.0

[View vitest-testing](https://www.claudepluginhub.com/plugins/secondsky-vitest-testing-plugins-vitest-testing-2)

## vulnerability-scanning

99

Implements automated security scanning for dependencies, code, and containers using tools like Trivy, Snyk, and npm audit. Use when setting up CI/CD security gates, conducting pre-deployment audits, or meeting compliance requirements.

2w

v3.0.0

[View vulnerability-scanning](https://www.claudepluginhub.com/plugins/secondsky-vulnerability-scanning-plugins-vulnerability-scanning-2)

## web-performance-audit

99

Web performance audits with Core Web Vitals, bottleneck identification, optimization recommendations. Use for page load times, performance reviews, UX optimization, or encountering LCP, FID, CLS issues, resource blocking, render delays.

3mo

v3.0.0

[View web-performance-audit](https://www.claudepluginhub.com/plugins/secondsky-web-performance-audit-plugins-web-performance-audit-2)

## web-performance-optimization

99

·

1

Optimizes web application performance through code splitting, lazy loading, caching strategies, and Core Web Vitals monitoring. Use when improving page load times, implementing service workers, or reducing bundle sizes.

3mo

v3.0.0

[View web-performance-optimization](https://www.claudepluginhub.com/plugins/secondsky-web-performance-optimization-plugins-web-performance-optimization-2)

## websocket-implementation

99

Implements real-time WebSocket communication with connection management, room-based messaging, and horizontal scaling. Use when building chat systems, live notifications, collaborative tools, or real-time dashboards.

2w

v3.0.0

[View websocket-implementation](https://www.claudepluginhub.com/plugins/secondsky-websocket-implementation-plugins-websocket-implementation-2)

## woocommerce-backend-dev

99

Add or modify WooCommerce backend PHP code following project conventions. Use when creating new classes, methods, hooks, or modifying existing backend code in WooCommerce projects.

2w

v3.0.0

[View woocommerce-backend-dev](https://www.claudepluginhub.com/plugins/secondsky-woocommerce-backend-dev-plugins-woocommerce-backend-dev-2)

## woocommerce-code-review

99

Review WooCommerce code changes for coding standards compliance. Use when reviewing code locally, performing automated PR reviews, or checking code quality in WooCommerce projects.

2w

v3.0.0

[View woocommerce-code-review](https://www.claudepluginhub.com/plugins/secondsky-woocommerce-code-review-plugins-woocommerce-code-review-2)

## woocommerce-copy-guidelines

99

Guidelines for UI text and copy in WooCommerce. Use when writing user-facing text, labels, buttons, messages, or documentation in WooCommerce projects.

2w

v3.0.0

[View woocommerce-copy-guidelines](https://www.claudepluginhub.com/plugins/secondsky-woocommerce-copy-guidelines-plugins-woocommerce-copy-guidelines-2)

## woocommerce-dev-cycle

99

Run tests, linting, and quality checks for WooCommerce development. Use when running tests, fixing code style, or following the development workflow in WooCommerce projects.

2w

v3.0.0

[View woocommerce-dev-cycle](https://www.claudepluginhub.com/plugins/secondsky-woocommerce-dev-cycle-plugins-woocommerce-dev-cycle-2)

## wordpress-plugin-core

99

·

3

WordPress plugin development with hooks, security, REST API, custom post types. Use for plugin creation, $wpdb queries, Settings API, or encountering SQL injection, XSS, CSRF, nonce errors.

3mo

v3.0.0

[View wordpress-plugin-core](https://www.claudepluginhub.com/plugins/secondsky-wordpress-plugin-core-plugins-wordpress-plugin-core-2)

## xss-prevention

99

Prevents Cross-Site Scripting attacks through input sanitization, output encoding, and Content Security Policy. Use when handling user-generated content, implementing rich text editors, or securing web applications.

2w

v3.0.0

[View xss-prevention](https://www.claudepluginhub.com/plugins/secondsky-xss-prevention-plugins-xss-prevention-2)

## zod

99

TypeScript-first schema validation and type inference. Use for validating API requests/responses, form data, env vars, configs, defining type-safe schemas with runtime validation, transforming data, generating JSON Schema for OpenAPI/AI, or encountering missing validation errors, type inference issues, validation error handling problems. Zero dependencies (2kb gzipped).

2w

v3.0.0

[View zod](https://www.claudepluginhub.com/plugins/secondsky-zod-plugins-zod-2)

## zustand-state-management

99

Zustand state management for React with TypeScript. Use for global state, Redux/Context API migration, localStorage persistence, slices pattern, devtools, Next.js SSR, or encountering hydration errors, TypeScript inference issues, persist middleware problems, infinite render loops.

2w

v3.0.0

[View zustand-state-management](https://www.claudepluginhub.com/plugins/secondsky-zustand-state-management-plugins-zustand-state-management-2)

## Related Marketplaces

[**antigravity-awesome-skills** \\
\\
33.7K\\
\\
·\\
\\
0plugins\\
\\
Claude Code marketplace entries for the plugin-safe Antigravity Awesome Skills library and its compatible editorial bundles.](https://www.claudepluginhub.com/marketplaces/sickn33-antigravity-awesome-skills) [**claude-plugins-official** \\
\\
17.2K\\
\\
·\\
\\
0plugins\\
\\
Directory of popular Claude Code extensions including development tools, productivity plugins, and MCP integrations](https://www.claudepluginhub.com/marketplaces/anthropics-claude-plugins-official) [**trailofbits** \\
\\
4.6K\\
\\
·\\
\\
0plugins\\
\\
Claude Code plugins from Trail of Bits for enhanced AI-assisted security analysis and development](https://www.claudepluginhub.com/marketplaces/trailofbits-trailofbits)

Stats

Plugins170

Stars99

Installs2

Updated9 days ago

Links

[View on GitHub](https://github.com/secondsky/claude-skills) [View Marketplace JSON](https://www.claudepluginhub.com/marketplaces/themed/secondsky-claude-skills/marketplace.json)

Categories

[deployment](https://www.claudepluginhub.com/plugins?category=deployment) [productivity](https://www.claudepluginhub.com/plugins?category=productivity) [utilities](https://www.claudepluginhub.com/plugins?category=utilities) [data](https://www.claudepluginhub.com/plugins?category=data) [security](https://www.claudepluginhub.com/plugins?category=security)

claude-skills Marketplace - Claude Code Plugins \| ClaudePluginHub