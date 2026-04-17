# Codex CLI как research-агент: интеграция с research-скиллами

**Query:** Best practices for using Codex CLI as a research agent
**Level:** L3 (Expert)
**Sources:** 22+
**Generated:** 2026-04-16

## Executive Summary

GPT-5.4 с подпиской Pro ($200) — это мощный research-инструмент: BrowseComp 89.3% (state of the art), 1M контекстное окно, agentic web search. **Codex CLI** (`codex exec`) позволяет использовать эти возможности программно через `-c 'web_search="live"'`. Однако CLI-версия web search **значительно слабее** полноценного ChatGPT browsing: есть ограничения на количество запросов за вызов, rate limits на Pro подписке, и cached режим по умолчанию.

**Оптимальная стратегия:** использовать Codex CLI как **независимый research-канал** (другая модель, другой поисковый индекс) в нашем L2+ пайплайне — НЕ как замену Firecrawl+Tavily, а как дополнительный perspective.

## 1. Что GPT-5.4 умеет в web research

### BrowseComp Benchmark
- GPT-5.4 Standard: **82.7%** (vs GPT-5.2: 65.8%)
- GPT-5.4 Pro: **89.3%** — state of the art [1, 4, 5]
- Бенчмарк измеряет persistent browsing — поиск hard-to-find информации через несколько раундов

### Agentic Web Search
- GPT-5.4 "is stronger at answering questions that require pulling together information from many sources" [7]
- Может "persistently search across multiple rounds to identify the most relevant sources" [7]
- Особенно хорош для "needle-in-a-haystack" вопросов [7]

### Tool Search (новое в GPT-5.4)
- Снижает token usage на **47%** для tool-heavy workflows [4]
- Агент автоматически находит нужные tools без перебора всех описаний [6]

## 2. Codex CLI: как именно работает web search

### Два режима [10]
1. **Cached (default):** "OpenAI-maintained index of web results" — предпроиндексированные результаты, НЕ live. Снижает prompt injection risk, но данные могут быть не самые свежие.
2. **Live:** полноценный web search. Включается через `--search` (interactive) или `-c 'web_search="live"'` (exec).

### Ключевая команда для research [16]
```bash
codex exec -c 'web_search="live"' --sandbox read-only -o /tmp/output.md "PROMPT"
```

### Флаги [16, 17]
| Флаг | Назначение |
|------|------------|
| `-c 'web_search="live"'` | Live web search (ОБЯЗАТЕЛЬНО для research) |
| `--sandbox read-only` | Read-only — research не пишет файлы |
| `-o FILE` | Захват результата в файл |
| `--full-auto` | Без запросов подтверждения |
| `-m MODEL` | Выбор модели (default: gpt-5.4) |
| `--skip-git-repo-check` | Работа вне git-репо |

### Multi-turn research [16]
```bash
# Первый запрос
codex exec -c 'web_search="live"' --sandbox read-only "Research [topic]"
# Продолжение на той же сессии
codex exec resume --last "Now dig deeper into [aspect 2]"
```

## 3. Паттерн "codex-researcher" (community)

**Найден готовый шаблон:** [sherifkozman/codex-researcher.md](https://gist.github.com/sherifkozman/9c62faaee3e4843f9c7cbf5f3343df4f) — Claude Code sub-agent, использующий Codex CLI для research.

**Ключевая идея:** Claude Code **делегирует** research-задачу Codex через `codex exec`, получает результат, и синтезирует его.

**Workflow:**
1. Understand request → определить scope
2. Craft prompt → структурированный промпт с секциями
3. Execute → `codex exec -c 'web_search="live"'`
4. Analyze → проверить completeness
5. Follow up → `codex exec resume --last` если есть gaps
6. Synthesize → итоговый формат

## 4. ChatGPT Pro ($200) — что даёт для research

| Feature | Plus ($20) | Pro ($200) |
|---------|-----------|------------|
| Deep Research | 10 runs/month | **250 runs/month** |
| Model | GPT-5.4 | **GPT-5.4 + GPT-5.4 Pro** |
| BrowseComp | 82.7% | **89.3%** |
| Usage limits | 160 msg/3h | **Unlimited** |
| Codex access | Yes | **Yes + priority** |

**Важно:** Pro даёт "unlimited" access, но **есть скрытые rate limits** — community reports показывают, что при heavy usage можно упереться в weekly caps [community forums].

## 5. Ограничения и риски (Critic findings)

### Confirmed issues
1. **CLI web search ≠ ChatGPT browsing.** Codex CLI web search инструмент ограничен по сравнению с полноценным browsing в ChatGPT. Количество поисковых запросов за один вызов лимитировано [critic].
2. **Rate limits реальны.** Community reports: Pro users hit weekly usage caps in hours при heavy tasks. "Unlimited" — маркетинг, есть throughput ceilings [community forums].
3. **Prompt injection risk.** Live web search = model ingests arbitrary web content. Нужно sanitize output [10].
4. **Multi-turn research через `resume` не гарантирует сохранение web-контекста** между сессиями — designed for coding, not research [critic].

### Mitigations
- Использовать Codex как ONE channel, не единственный
- Sanitize output перед синтезом
- Ставить конкретные, bounded промпты
- Не полагаться на resume для critical findings — лучше новый exec

## 6. Оптимальная интеграция в наши research-скиллы

### Рекомендуемый паттерн: Codex как independent researcher agent

**НЕ** заменять Firecrawl+Tavily. **Добавить** Codex как третий канал с другой моделью и другим поисковым индексом.

### Конкретная интеграция по уровням:

#### L0 (quick-research): НЕ подключать
- Слишком быстрый, Codex exec startup overhead ~10-15 сек

#### L1 (research): Опционально
- Можно использовать как alternative search для одного из 3 подвопросов
- Экономит Tavily credits

#### L2 (deep-research): ДА — reflection channel
- В gap analysis (Step 2.1): вместо повторного Firecrawl+Tavily, делегировать 1 из 2 follow-up вопросов Codex'у
- Codex ищет с другим bias, другим индексом — лучшее coverage
- `codex exec -c 'web_search="live"' --sandbox read-only -o .firecrawl/research/<slug>/L2/codex-findings.md "Research: <follow-up question>. Include sources with URLs."`

#### L3 (expert-research): ДА — independent critic + researcher
- **Critic agent:** заменить или дополнить Claude-critic Codex-critic'ом
- **3-angle search:** Angle 3 (neutral) → Codex exec
- Разная модель = реально независимая перспектива

#### L4 (academic-research): ДА — Researcher C
- Добавить Codex как третьего researcher в crew
- Researcher A (Claude): primary academic sources
- Researcher B (Claude): cross-domain
- **Researcher C (Codex):** verification + contrarian angle

#### L5 (ultra-research): ДА — в recursive loop
- Каждая итерация: один из 3 researchers = Codex
- Fact-checker: Codex проверяет claims, найденные Claude (cross-model verification)

### Конкретная реализация (шаблон для скиллов):

```bash
# Research query via Codex
codex exec \
  -c 'web_search="live"' \
  --sandbox read-only \
  --skip-git-repo-check \
  -o ".firecrawl/research/<slug>/<level>/codex-research.md" \
  "You are a research analyst. Research the following question thoroughly using web search.

Question: <QUESTION>

Requirements:
1. Search for multiple perspectives (proponents, critics, neutral)
2. Include specific data, numbers, benchmarks where available
3. Cite every source with full URL
4. Flag any contradictions between sources
5. Rate confidence: High/Medium/Low for each claim
6. Output in markdown with clear sections

Focus on sources from 2025-2026."
```

## 7. Преимущества over Perplexity

| Аспект | Perplexity MCP (был) | Codex CLI (предлагается) |
|--------|---------------------|------------------------|
| Модель | Perplexity's model | GPT-5.4 Pro (89.3% BrowseComp) |
| Поиск | Perplexity search | OpenAI web search (live) |
| Reasoning | Basic | xhigh reasoning effort |
| Multi-turn | Нет | `codex exec resume --last` |
| Output | API response | Structured markdown файл |
| Стоимость | $20/month subscription | Включён в $200 Pro |
| Независимость | Зависим от Perplexity API | Локальный CLI |
| MCP tools | Нет | Firecrawl MCP, DataForSEO MCP |

## Recommendation

**Добавить Codex CLI в research-скиллы L2+ как третий research канал.** Это даёт:
1. Cross-model verification (Claude ищет + Codex ищет = разные bias)
2. Другой поисковый индекс (OpenAI web search vs Tavily vs Firecrawl)
3. GPT-5.4 Pro reasoning (89.3% BrowseComp)
4. Нулевые дополнительные затраты (входит в Pro $200)
5. MCP tools в Codex (Firecrawl, DataForSEO) — дополнительные каналы

**НЕ делать:** полностью заменять Firecrawl+Tavily на Codex. Codex — дополнительный perspective, не основной.

## Sources

1. [Introducing GPT-5.4](https://openai.com/index/introducing-gpt-5-4/) — OpenAI official
2. [Codex Non-interactive mode](https://developers.openai.com/codex/noninteractive) — OpenAI docs
3. [Codex Subagents](https://developers.openai.com/codex/subagents) — OpenAI docs
4. [GPT 5.4 Complete Guide](https://www.nxcode.io/resources/news/gpt-5-4-complete-guide-features-pricing-models-2026) — NxCode
5. [GPT-5.4 Features & Benchmarks](https://almcorp.com/blog/gpt-5-4/) — ALM Corp
6. [Using GPT-5.4 API Guide](https://developers.openai.com/api/docs/guides/latest-model) — OpenAI docs
7. [Introducing GPT-5.4 (detailed)](https://openai.com/index/introducing-gpt-5-4/) — OpenAI
8. [Harness Engineering](https://openai.com/index/harness-engineering/) — OpenAI
9. [Agentic Engineering Patterns](https://simonw.substack.com/p/agentic-engineering-patterns) — Simon Willison
10. [Codex CLI Features](https://developers.openai.com/codex/cli/features) — OpenAI docs
11. [Codex vs Claude Code 2026](https://blakecrosley.com/blog/codex-vs-claude-code-2026) — Blake Crosley
12. [Codex App Guide](https://almcorp.com/blog/openai-codex-app-macos-guide-features-pricing-security/) — ALM Corp
13. [ChatGPT Pricing Breakdown](https://tldv.io/blog/chatgpt-pricing/) — tldv.io
14. [Claude Max vs ChatGPT Pro](https://www.nxcode.io/resources/news/claude-max-vs-chatgpt-pro-2026-premium-ai-comparison) — NxCode
15. [Codex Best Practices](https://developers.openai.com/codex/learn/best-practices) — OpenAI docs
16. [codex-researcher gist](https://gist.github.com/sherifkozman/9c62faaee3e4843f9c7cbf5f3343df4f) — sherifkozman
17. [Codex CLI Reference](https://developers.openai.com/codex/cli/reference) — OpenAI docs
