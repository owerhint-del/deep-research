# Библиотека кейсов

20+ реальных сценариев с готовыми промптами, показывающие какую ступень брать и что получишь на выходе.

> 🌐 [English version](../USE_CASES.md)

---

## Оглавление

- [Разработка](#разработка)
- [DevOps и инфра](#devops-и-инфра)
- [Продукт и бизнес](#продукт-и-бизнес)
- [Маркетинг и рост](#маркетинг-и-рост)
- [Академические и журналистские](#академические-и-журналистские)
- [Личное обучение](#личное-обучение)

---

## Разработка

### 1. Выбор фреймворка

**Сценарий:** стартуешь новый проект, взвешиваешь два фреймворка.

```
/deep-research Next.js vs SvelteKit для B2B SaaS с SEO-требованиями в 2026
```

**Получишь:** ~2 000-словное сравнение по измерениям (DX, perf, экосистема, найм), surfaced tradeoffs по противоречиям, confidence-грейдинг утверждений.

---

### 2. Миграция библиотеки

**Сценарий:** рассматриваешь смену core-зависимости.

```
/expert-research миграция с Prisma на Drizzle на 200-табличной Postgres-схеме — breaking changes, effort, подводные камни
```

**Получишь:** L3 с critic review. Executive summary говорит go/no-go. Critic challenges «no-go» аргументы.

---

### 3. Въезд в новый релиз

**Сценарий:** новая major-версия инструмента, которым пользуешься.

```
/research что нового в React 19 — production readiness, breaking changes, migration path
```

**Получишь:** быстрый структурированный обзор, идеален для шаринга с командой.

---

### 4. Оценка архитектурного паттерна

**Сценарий:** стоит ли адаптировать паттерн?

```
/expert-research event sourcing для нашего billing-сервиса — benefits vs сложность для команды 5 человек
```

**Получишь:** L3 — critic-агент явно оспаривает «простые use case» аргументы, что именно то, что нужно при архитектурном коммите.

---

### 5. Разведка root-cause бага

**Сценарий:** странная ошибка, интересно — другие сталкивались?

```
/quick-research "Error: Hydration failed because the initial UI does not match" Next.js 15
```

**Получишь:** быстрый лукап — если известная проблема, фикс найдёшь за минуту. Если нет — эскалируй на `/research`.

---

## DevOps и инфра

### 6. Выбор облачного провайдера

**Сценарий:** решение где хостить новый сервис.

```
/deep-research Hetzner Cloud vs DigitalOcean vs Hostinger VPS для Node.js API на 5K req/sec в 2026
```

**Получишь:** L2 с surfaced противоречиями (pricing claims дико расходятся между источниками — хорошо, что флагнуто).

---

### 7. Выбор БД

```
/expert-research PostgreSQL vs CockroachDB vs Planetscale для multi-region SaaS на масштабе 10K платящих клиентов
```

---

### 8. Orchestration tooling

```
/expert-research Kubernetes vs Nomad vs Docker Swarm для 5-сервисного стартапа — operational burden и найм
```

---

### 9. CI/CD пайплайн

```
/deep-research GitHub Actions vs CircleCI vs Depot — скорость билдов и стоимость для monorepo CI в 2026
```

---

## Продукт и бизнес

### 10. Анализ конкурентов

```
/expert-research Linear vs Jira vs Shortcut для engineering-команды 20 человек — реальный опыт пользователей, а не vendor claims
```

**Подсказка:** фраза «not vendor claims» биасит поиск на форумы, ревью, independent блоги. L3 neutral-angle агент усиливает это.

---

### 11. Pricing research

```
/deep-research модели ценообразования B2B AI SaaS в 2025-2026 — usage-based vs seat-based vs hybrid
```

---

### 12. Market sizing

```
/academic-research размер и рост рынка developer tooling 2024-2026 с methodology rigor
```

**Почему L4:** цифры здесь важны, аннотированная библиография даёт рейтинги качества источников.

---

### 13. Regulatory scan

```
/academic-research требования EU AI Act compliance для LLM-based SaaS продуктов
```

---

## Маркетинг и рост

### 14. Channel research

```
/expert-research состояние Telegram Ads для gaming/entertainment apps в 2026 — workflow, инструменты, реальные CPM
```

---

### 15. SEO landscape

```
/deep-research как Google AI Overviews изменили SEO-стратегию в 2025-2026
```

---

### 16. Content strategy

```
/research как успешные B2B SaaS компании структурируют блог в 2026 — cadence, темы, дистрибуция
```

---

### 17. Ad platform deep-dive

```
/expert-research Google Ads vs Meta Ads vs Reddit Ads для developer-tool B2B SaaS — CAC, качество, tooling
```

---

## Академические и журналистские

### 18. Литобзор

```
/academic-research mixture-of-experts архитектуры в LLM 2023-2026 — обзор
```

**Вывод:** ~5 000 слов с таймлайном, methodology секцией, аннотированной библиографией. Достаточно хорош чтобы быть стартовой точкой для paper или internal whitepaper.

---

### 19. Фактчек с trail

```
/deep-research утверждения, что GPT-5.4 достигает 89.3% на BrowseComp benchmark — первичные источники и верификация
```

---

### 20. Мульти-перспективное исследование

```
/academic-research продуктивность удалёнки — исследования за и против, методологии, что значат противоречия
```

---

### 21. Анализ трендов

```
/expert-research рост и спад крипто-ориентированных соцсетей 2021-2026 — что сработало, что нет, почему
```

---

## Личное обучение

### 22. Онбординг в новый концепт

```
/research что такое Model Context Protocol — с точки зрения разработчика, не маркетинга
```

---

### 23. Deep-dive в специализацию

```
/ultra-research полный knowledge vault про prompt caching в Claude API — для production engineering-команды
```

**Вывод:** Vault с executive summary, глоссарием, playbooks для частых задач, counter-arguments к частым советам, open questions.

---

### 24. Career-skill research

```
/deep-research что отличает senior от staff инженеров в product-focused компаниях в 2026
```

---

### 25. Hobby deep-dive

```
/research домашняя обжарка кофе — оборудование, зёрна, техника, реалистичные ожидания
```

---

## Антипаттерны

Для чего лестница **не подходит**:

| Не используй | Почему |
|--------------|--------|
| Простые code-лукапы, которые есть в доках | Используй `mcp__context7__query-docs` — он для этого сделан |
| Вопросы, где важны свежие новости | L1–L5 приоритизируют глубину над свежестью — для breaking news бери `/quick-research` + чекай таймстемпы |
| Вопросы с одним явным авторитетным источником | Если знаешь источник, просто скрейпи его: `firecrawl scrape <url>` |
| Субъективное мнение (напр. «чистый ли код X») | Research surface'ит что говорят источники, а не суждения о качестве |
| Генерация контента (блогпосты, письма) | Сначала research, *затем* проси Claude писать — не смешивай |

---

## Сабмит нового кейса

Нашёл клёвый prompt-паттерн? Открывай PR с добавлением в этот файл. См. [CONTRIBUTING.md](../../CONTRIBUTING.md).
