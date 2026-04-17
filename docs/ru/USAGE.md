# Гайд по использованию

Как вызывать каждую ступень research-лестницы, что она продюсит, и как выбирать правильную.

> 🌐 [English version](../USAGE.md)

---

## TL;DR — как выбирать ступень

```
"Какая последняя версия / кто / когда / есть ли X"  →  L0 /quick-research

"Объясни X" / "Как работает Y" / "Что нового"       →  L1 /research

"X vs Y" / "Стоит ли мигрировать" / "Нетривиально"   →  L2 /deep-research

"Стратегическое решение" / "Pros/cons миграции"      →  L3 /expert-research

"Литобзор" / "Научный обзор"                         →  L4 /academic-research

"Полная база знаний" / "Стать экспертом"             →  L5 /ultra-research
```

**Правило:** начинай на ступень ниже, чем кажется нужно. Поднимайся только если вывод недостаточен.

---

## L0 — `/quick-research`

### Что это

Самая быстрая ступень — веб-серч с цитатами. Без полных скрейпов, без per-source summary.

### Когда использовать

- Номера версий, даты релизов
- «Кто что сказал» быстрые ссылки
- «Есть ли X в Y?» справки
- Разведка перед коммитом к более глубокой ступени

### Когда НЕ использовать

- Всё, что требует синтеза между источниками
- Всё, что ты будешь использовать как вход для решения
- Многогранные вопросы

### Примеры промптов

```
/quick-research последняя стабильная версия Bun
/quick-research когда Anthropic выпустил Claude 4.7
/quick-research поддерживает ли Next.js 15 Turbopack в production
/quick-research дата релиза GPT-5.4
```

### Выход

Короткий абзац (50–150 слов) с inline-цитатами, завершается блоком `Sources:` с 3–5 URL.

### Артефакты

Нет. Работает в основном диалоге — папка `.firecrawl/research/` не создаётся.

### Время / стоимость

~1 минута. ~10 Tavily credits. Zero Firecrawl.

---

## L1 — `/research`

### Что это

**Ступень-фундамент**. Добавляет декомпозицию запроса (planner) и per-source summary поверх L0.

Это также то, что вызывает каждая верхняя ступень первой. Когда запускаешь L3 — он начинает с того, что запускает L1 внутри себя.

### Когда использовать

- «Объясни X» темы, где хочется структуру
- «Что нового в X в 2026»
- Въезд в незнакомый framework/библиотеку/концепт
- Default когда юзер не указал глубину

### Примеры промптов

```
/research чем Tailwind CSS v4 отличается от v3
/research текущее состояние Rust web frameworks
/research что такое Model Context Protocol
/research как transformer-модели работают с длинным контекстом
```

### Пайплайн

1. **CLARIFY** — если запрос неоднозначный, Claude задаёт один вопрос
2. **PLAN** — декомпозиция в 3 под-вопроса
3. **SEARCH** — параллельные Firecrawl + Tavily под каждый под-вопрос
4. **READ** — скрейп топ-10–15 URL с `firecrawl scrape --only-main-content`
5. **SUMMARIZE** — один `.md` на источник: тайтл, key findings, цитаты
6. **REPORT** — ~1 000-словный структурированный синтез с библиографией

### Артефакты

```
.firecrawl/research/<slug>/L1/
├── plan.md              # Под-вопросы
├── search-1.json        # Сырые результаты под-вопрос 1
├── search-2.json
├── search-3.json
├── sources/             # Полные скрейпы (10–15 .md файлов)
├── summaries/           # Per-source дайджесты
└── report.md            # Финальный синтез
```

### Время / стоимость

~5 мин. ~20 Tavily credits. 10–15 Firecrawl скрейпов.

---

## L2 — `/deep-research`

### Что это

Добавляет **reflection loop** поверх L1. После того как L1 выдаёт отчёт, L2:

1. Анализирует пробелы в отчёте
2. Пишет 2 follow-up под-вопроса
3. Прогоняет второй раунд поиска + скрейпа
4. Выносит противоречия между источниками
5. Грейдит каждое утверждение с confidence (H/M/L)

> ⚠️ **v0.1.1+**: L2 имеет 4 обязательных verification checkpoint для предотвращения «hollow synthesis». См. SKILL.md файла deep-research.

### Когда использовать

- `X vs Y` сравнения
- «Стоит ли мигрировать с A на B»
- Нетривиальные технические вопросы, где один проход может упустить нюансы
- Default для «подробно», «серьёзно», «глубоко»

### Примеры промптов

```
/deep-research PostgreSQL vs MongoDB для multi-tenant e-commerce
/deep-research стоит ли мигрировать с Webpack на Vite на монорепо с 300 компонентами
/deep-research состояние Telegram Ads для гейминг-приложений в 2026
/deep-research Zustand vs Jotai vs Redux Toolkit для React-команды, новой в state management
```

### Дополнительные артефакты (поверх L1)

```
.firecrawl/research/<slug>/L2/
├── gaps.md              # Вывод рефлексии — что L1 упустил
├── plan.md              # Follow-up под-вопросы
├── sources/             # Новые скрейпы (10–15 новых .md)
├── summaries/
├── contradictions.md    # Несогласия между источниками
└── report.md            # ~2 000-словный синтез, claims грейд H/M/L
```

### Время / стоимость

~12 мин всего (L1: ~5 + L2 слой: ~7). ~50 Tavily credits. 20–30 Firecrawl скрейпов.

---

## L3 — `/expert-research`

### Что это

Добавляет **независимый critic-агент** и **neutral-angle-исследователя** поверх L2.

После того как L2 завершается, L3 спавнит:

1. **Critic agent** — читает отчёт L2 adversarially, оспаривает выводы, ищет недостающие углы
2. **Neutral-angle researcher** — делает свежий поиск с намеренно другой рамкой
3. **Human-in-the-loop чекпоинт** (опционально) — апрув плана до дорогой фазы

### Когда использовать

- Стратегические решения (высокая цена ошибки)
- Технологические миграции, затрагивающие всю команду
- Исследования, где нужен второй взгляд
- Запросы, помеченные «important»

### Примеры промптов

```
/expert-research стоит ли нашей команде из 20 человек переходить с REST на GraphQL federation
/expert-research подходит ли Rust для нашего нового data pipeline сервиса
/expert-research Kubernetes vs Nomad для 5-сервисного стартапа в 2026
```

### Дополнительные артефакты

```
.firecrawl/research/<slug>/L3/
├── critic-review.md     # Adversarial проход по L2 отчёту
├── neutral-angle.md     # Свежая перспектива
└── report.md            # 3 000-словный executive отчёт
```

### Время / стоимость

~20 мин всего. ~100 Tavily credits. 40–60 Firecrawl скрейпов.

---

## L4 — `/academic-research`

### Что это

Добавляет **слой академических источников** (arXiv, Google Scholar, DOI-backed papers) и **полный multi-agent crew** поверх L3.

Agent crew:

- **Planner** — оркестрирует под-вопросы
- **Researcher A** — общие веб-источники
- **Researcher B** — академические базы
- **Critic** — adversarial review
- **Editor** — финальный синтез

Выход включает **timeline analysis** и **аннотированную библиографию с рейтингом качества источников**.

### Когда использовать

- Научные обзоры
- Литобзоры
- Research-grade расследования с integrity цитат
- Когда credibility источников важна для downstream использования

### Примеры промптов

```
/academic-research MoE-архитектуры в LLM 2023-2026
/academic-research методологии исследования продуктивности удалёнки
/academic-research доказательства за и против психологической безопасности в engineering-командах
/academic-research ландшафт бенчмарков retrieval-augmented generation
```

### Дополнительные артефакты

```
.firecrawl/research/<slug>/L4/
├── academic-sources/    # arXiv/Scholar скрейпы
├── timeline.md          # Хронологический синтез поля
├── annotated-bibliography.md   # Каждый источник с рейтингом качества
└── report.md            # ~5 000-словный отчёт с methodology секцией
```

### Время / стоимость

~40 мин. ~300 Tavily credits. 80–120 Firecrawl скрейпов.

---

## L5 — `/ultra-research`

### Что это

**Максимальная-глубина ступень**. Строит полный knowledge vault с:

- Executive summary
- Глоссарий
- Таймлайн
- Playbooks (how-to гайды, извлечённые из findings)
- Counter-arguments
- Open questions
- Рекурсивное исследование до **knowledge saturation** (останавливается, только когда follow-up запросы не возвращают новые факты)
- Peer-review симуляция между агентами
- Полный agent crew (7+ ролей)

### Когда использовать

- Хочется стать экспертом по теме
- Построение internal wiki / onboarding материалов
- Long-term reference документация

### Примеры промптов

```
/ultra-research MCP-протокол — полный knowledge vault для нашей команды
/ultra-research всё про prompt caching в Claude API для production-приложений
/ultra-research полный ландшафт AI agent orchestration frameworks
```

### Артефакты

Полная структура vault:

```
.firecrawl/research/<slug>/L5/
├── executive-summary.md
├── glossary.md
├── timeline.md
├── playbooks/
│   ├── how-to-<task-1>.md
│   └── how-to-<task-2>.md
├── counter-arguments.md
├── open-questions.md
├── annotated-bibliography.md
└── report.md            # 10 000+ словный главный отчёт
```

Также авто-синкается в твой Obsidian vault, если настроен.

### Время / стоимость

1+ час. ~800 Tavily credits. 150+ Firecrawl скрейпов.

---

## Паттерны и подсказки

### Паттерн: разведка, потом deep-dive

```
/quick-research что такое CRDT                     # L0 — вообще ли релевантно?
/research реализации CRDT в JavaScript             # L1 — если да, обзор
/deep-research Yjs vs Automerge для collaborative editor   # L2 — выбор из двух
```

Каждая ступень стоит больше. Разведка L0 первой предотвращает сжигание L3 на том, что ты отбросишь.

### Паттерн: параллельное исследование

Если несколько несвязанных вопросов — запускай их в отдельных сессиях Claude Code, не цепочкой. Каждая получит свою `.firecrawl/research/<slug>/`.

### Паттерн: переиспользование артефактов

Папка `.firecrawl/research/<slug>/` — просто markdown + JSON. Можешь:

- Закоммитить в wiki проекта
- Скормить обратно Claude как контекст для follow-up: `"вот research findings из research/L2/report.md, теперь помоги написать RFC"`
- Шарить с тиммейтами — audit trail полностью портабельный

### Паттерн: апгрейд на лету

Если вывод L2 недостаточен — эскалируй:

```
/expert-research <тот же запрос>
```

L3 переиспользует артефакты L1/L2 если они уже есть в той же slug-папке, запустит только L3 слой поверх.

---

## Траблшутинг использования

| Симптом | Вероятная причина | Фикс |
|---------|-------------------|------|
| Отчёт цитирует источники, но `.firecrawl/.../sources/` пусто | L2 пропустил шаг скрейпа | Перезапусти; см. [TROUBLESHOOTING.md](../TROUBLESHOOTING.md#l2-hollow-synthesis) |
| Tavily «rate limit» ошибки | Free tier исчерпан | Жди месячный reset или апгрейд |
| Codex канал таймаутит | Heavy weekly usage | Временно отключи Codex, см. [CODEX_INTEGRATION.md](../CODEX_INTEGRATION.md) |
| Неверный язык в отчёте | Claude авто-детектит из запроса | Добавь `"отвечай по-русски"` / `"respond in English"` в промпт |

Полный каталог проблем: [docs/TROUBLESHOOTING.md](../TROUBLESHOOTING.md).
