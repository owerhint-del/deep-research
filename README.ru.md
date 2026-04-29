# Deep Research — Систематическая лестница ресерча для Claude Code

> **Шесть композируемых research-скиллов (L0→L5).** От 60-секундного фактчека до 40-минутного академического исследования со 120+ источниками. Бери нужную глубину под задачу.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-blue.svg)](https://claude.com/claude-code)
[![English](https://img.shields.io/badge/lang-English-blue.svg)](README.md)

---

## Что это такое?

Набор из шести [Claude Code](https://claude.com/claude-code) скиллов, образующих **research-лестницу**. Каждая ступень композируется поверх предыдущей, добавляя конкретные возможности:

| Ступень | Скилл | Время | Источники | На выходе | Подходит для |
|:-------:|-------|:-----:|:---------:|-----------|--------------|
| **L0** | `/quick-research` | ~1 мин | 3–5 | 1-абзацный ответ с цитатами | Фактчеки, быстрые справки, «последняя версия X» |
| **L1** | `/research` | ~5 мин | 10–15 | Структурированный отчёт ~1 000 слов | Стандартные обзоры, «как работает X» |
| **L2** | `/deep-research` | ~12 мин | 20–30 | Отчёт ~2 000 слов + противоречия | Выбор технологии, сравнения, нетривиальные задачи |
| **L3** | `/expert-research` | ~20 мин | 40–60 | Отчёт ~3 000 слов + ревью критика | Стратегические решения, миграции |
| **L4** | `/academic-research` | ~40 мин | 80–120 | Отчёт ~5 000 слов с библиографией | Research-grade, научные обзоры |
| **L5** | `/ultra-research` | 1+ час | 150+ | Полный knowledge vault (10 000+ слов) | Стать экспертом по теме |

### Специализированные скиллы (параллельно лестнице)

| Skill | Время | Источники | Output | Для чего |
|-------|:----:|:-------:|--------|----------|
| `/osint-research` | ~10–15 мин | 8–12 каналов | hybrid findings/dossier/graph отчёт | OSINT-разведка по сущности: домен, IP, email, человек, компания. См. `docs/OSINT_INTEGRATION.md`. |

**Ключевое свойство:** L3 вызывает L2, L2 вызывает L1. Каждый верхний уровень наследует основу нижнего и добавляет свой слой (рефлексия, критик, мульти-перспектива, академические источники, рекурсивные петли).

---

## Зачем это существует?

LLM-research страдает от трёх хронических проблем:

1. **По умолчанию поверхностный** — ad-hoc «поищи в вебе» даёт 1–2 источника и самоуверенный синтез без верификации.
2. **«Hollow synthesis» (пустой синтез)** — вывод *звучит* авторитетно, но нет audit trail. Невозможно проследить утверждение до источника.
3. **Загрязнение контекста** — сваливание ресерча в основной диалог забивает контекстное окно и ухудшает последующие tool-use.

Лестница решает каждую:

| Проблема | Решение |
|----------|---------|
| Поверхностность по умолчанию | Ступенчатая глубина — L0 для справки, L4 для литобзора |
| Пустой синтез | Каждый L1+ скрейпит полное содержимое, пишет per-source summary, грейдит confidence |
| Загрязнение контекста | Все артефакты живут в `.firecrawl/research/<slug>/` — основной чат остаётся чистым |

---

## Быстрый старт

### Требования

**Обязательно:**

- [Claude Code](https://claude.com/claude-code) CLI (любая свежая версия)
- [Firecrawl CLI](https://www.firecrawl.dev) — движок скрейпинга
- [Tavily MCP](https://tavily.com) — search API (бесплатный тариф OK)

**Опционально (для L2+ cross-model канала):**

- [OpenAI Codex CLI](https://developers.openai.com/codex/cli) + подписка ChatGPT Pro

Полный гайд: см. [docs/ru/INSTALLATION.md](docs/ru/INSTALLATION.md).

### Установка

```bash
git clone https://github.com/hint-shu/deep-research.git
cd deep-research
bash scripts/install.sh
```

Скрипт копирует содержимое `skills/*` в `~/.claude/skills/` и печатает следующие шаги (ключи API, тестовая команда).

### Первый запуск

```
/quick-research последняя стабильная версия Bun
/research чем Tailwind CSS v4 отличается от v3
/deep-research PostgreSQL vs MongoDB для e-commerce платформы в 2026
```

Всё. Каждый скилл пишет артефакты в `.firecrawl/research/<slug>/` в той директории, из которой запущен Claude Code.

---

## Как это работает

Каждый скилл — markdown-файл, который Claude Code грузит как инструкции. При вызове скилла Claude следует его пайплайну:

```
L3 Expert Research
  └─ вызывает L2 Deep Research
       └─ вызывает L1 Base Research
            ├─ 1. Plan     — декомпозиция запроса в 3 под-вопроса
            ├─ 2. Search   — параллельные Firecrawl + Tavily по каждому
            ├─ 3. Scrape   — полный контент страниц, файл на URL
            ├─ 4. Summarize— .md-сводка per-source (тайтл, факты, цитаты)
            └─ 5. Report   — синтез ~1 000 слов с библиографией
       ├─ 6. Reflection    — находит пробелы в отчёте L1
       ├─ 7. Follow-up     — 10–15 новых источников по пробелам
       ├─ 8. Contradiction — выносит несогласия между источниками
       └─ 9. Confidence    — грейдит каждое утверждение H/M/L
  ├─ 10. Critic agent      — независимый проход, оспаривает выводы
  ├─ 11. Neutral angle     — поиск со свежей точки зрения
  └─ 12. Executive summary — финальный отчёт на 3 000 слов
```

Структура артефактов после L3-прогона:

```
.firecrawl/research/postgres-vs-mongo-2026/
├── L1/
│   ├── plan.md              ← под-вопросы
│   ├── search-1.json        ← сырые результаты поиска
│   ├── sources/             ← полные скрейпы
│   │   ├── 01-aws-docs.md
│   │   └── 02-mongo-atlas.md
│   ├── summaries/           ← per-source дайджесты
│   └── report.md            ← синтез L1
├── L2/
│   ├── gaps.md              ← вывод рефлексии
│   ├── sources/             ← новые скрейпы
│   ├── contradictions.md
│   └── report.md            ← синтез L2
└── L3/
    ├── critic-review.md     ← adversarial проход
    ├── neutral-angle.md
    └── report.md            ← финальный executive отчёт
```

---

## Реальные кейсы

### Разработка

- **Выбор технологии** — `/deep-research Next.js vs SvelteKit для нашего e-commerce стартапа`
- **Миграция библиотеки** — `/deep-research миграция с Prisma на Drizzle — breaking changes и подводные камни`
- **Новый релиз** — `/research что нового в React 19 и production readiness`
- **Архитектурные паттерны** — `/expert-research стоит ли использовать CQRS в нашей multi-tenant SaaS`

### Бизнес и стратегия

- **Анализ рынка** — `/expert-research состояние Telegram Ads для гейминг-приложений в 2026`
- **Конкурентная разведка** — `/deep-research Linear vs Jira для engineering-команды 20 человек`
- **Pricing research** — `/research модели ценообразования B2B AI SaaS в 2025-2026`
- **Регуляторика** — `/academic-research требования EU AI Act для LLM-based SaaS продуктов`

### Академические и журналистские

- **Литобзор** — `/academic-research MoE-архитектуры в LLM 2023-2026`
- **Фактчек с trail** — `/deep-research утверждения о бенчмарке GPT-5.4 BrowseComp 89.3%`
- **Анализ трендов** — `/expert-research рост и спад крипто-ориентированных соцсетей`
- **Мульти-перспектива** — `/academic-research методологии исследований продуктивности удалёнки`

Полная библиотека с примерами промптов и ожидаемыми выходами: [docs/ru/USE_CASES.md](docs/ru/USE_CASES.md).

---

## Чем особенная эта лестница

| Фича | Что даёт |
|------|----------|
| **Композируемая лестница** | Каждая ступень наследует полный пайплайн нижних. Без дублирующего кода. |
| **Cross-model verification (L2+)** | Опциональный Codex CLI канал добавляет GPT-5.4 как второй независимый голос. Другой поисковый индекс, другая модель — меньше слепых зон. |
| **Confidence grading** | Каждое утверждение L2+ тегается H/M/L. Понятно, каким частям синтеза доверять. |
| **Surfacing противоречий** | L2 явно пишет `contradictions.md` — больше никаких скрытых несогласий между источниками. |
| **Critic agent (L3+)** | Отдельный агент ревьюит отчёт adversarially до того, как ты его увидишь. |
| **Per-source summaries** | Никогда не теряется audit trail — каждый цитируемый факт указывает на полный скрейп на диске. |

---

## Документация

| Документ | Что внутри |
|----------|-----------|
| [docs/ru/INSTALLATION.md](docs/ru/INSTALLATION.md) | Полная установка на macOS/Linux/WSL, все API-ключи, верификация |
| [docs/ru/USAGE.md](docs/ru/USAGE.md) | Каждый скилл с inputs, outputs и подсказками |
| [docs/ru/USE_CASES.md](docs/ru/USE_CASES.md) | 20+ реальных сценариев с готовыми промптами |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Философия дизайна — почему лестница, почему эти границы (EN) |
| [docs/CODEX_INTEGRATION.md](docs/CODEX_INTEGRATION.md) | Опциональный GPT-5.4 cross-model канал для L2+ (EN) |
| [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) | Частые проблемы и фиксы (EN) |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Как добавлять скиллы, улучшать пайплайны, открывать PR |

---

## Требования на глаз

| Компонент | Обязательно? | Бесплатный тариф? | Заметки |
|-----------|--------------|--------------------|---------|
| Claude Code | Да | — | Основной runtime |
| Firecrawl | Да | 500 скрейпов/мес | Для всех уровней |
| Tavily | L1+ | 1 000 поисков/мес | Пропустить можно только если живёшь на L0 |
| Codex CLI | Нет | Требует ChatGPT Pro | Открывает cross-model канал L2+ |

Полная стоимость на бесплатных тарифах: **0 ₽**. С Codex: уже имеющаяся подписка ChatGPT Pro ($200/мес) — без доп. API-платежей.

---

## Roadmap

- [x] v0.1 — Шестиступенчатая research-лестница (L0→L5)
- [x] v0.1 — Интеграция Firecrawl + Tavily
- [x] v0.1.1 — L2 verification checkpoints (фикс «hollow synthesis»)
- [x] v0.2 — Codex CLI cross-model канал (L2+)
- [x] v0.3 — Общая verification-библиотека + flagship example
- [x] v0.4 — Claude Code plugin manifest + миграция скиллов
- [x] v0.5 — Exa MCP (neural semantic search)
- [x] v0.6 — Perplexity MCP (answer engine)
- [ ] v0.7 — Kagi как пятый backend для consumer research
- [ ] v1.0 — Авто-синк L5 vault'ов в Obsidian

См. [CHANGELOG.md](CHANGELOG.md).

---

## Контрибьютинг

Контрибьюшены приветствуются — новые скиллы, новые бэкенды, улучшения пайплайнов, переводы. Начни с [CONTRIBUTING.md](CONTRIBUTING.md).

Good first issues:

- Улучшить L2 verification checkpoints
- Добавить новый search-бэкенд (Kagi, Exa, Brave Search)
- Написать use-case примеры для домена, который ещё не покрыт
- Перевести документацию на свой язык

---

## Лицензия

[MIT](LICENSE) — используй свободно, модифицируй свободно, attribution приветствуется, но не обязателен.

---

## Credits

Построено поверх:

- **[Claude Code](https://claude.com/claude-code)** — CLI от Anthropic
- **[Firecrawl](https://www.firecrawl.dev)** — движок веб-скрейпинга
- **[Tavily](https://tavily.com)** — search API для research
- **[OpenAI Codex CLI](https://developers.openai.com/codex)** — опциональный cross-model канал

Изначально спроектировано [@hint-shu](https://github.com/hint-shu) как внутренний research-инструментарий. Выложено в open-source, потому что хороший систематический ресерч не должен быть закрытым знанием.
