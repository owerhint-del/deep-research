# Гайд по установке

Полная настройка research-лестницы на macOS, Linux и Windows (WSL).

> 🌐 [English version](../INSTALLATION.md)

---

## Обзор

Три пути установки:

| Путь | Когда использовать | Время |
|------|--------------------|-------|
| **A. Быстрый** | Хочешь попробовать сразу, Claude Code уже есть | 5 мин |
| **B. Полный** | Нужны все шесть уровней включая L5 с Codex | 20 мин |
| **C. Ручной** | Хочешь аудировать каждый шаг, или `install.sh` упал | 30 мин |

---

## Требования

Для всех путей:

| Инструмент | Проверить командой | Установить если нет |
|------------|---------------------|----------------------|
| Claude Code | `claude --version` | [claude.com/claude-code](https://claude.com/claude-code) |
| git | `git --version` | Обычно предустановлен; `brew install git` / `apt install git` |
| Bash 4+ или Zsh | `echo $SHELL` | Default на macOS/Linux |

Опционально, но рекомендуется:

| Инструмент | Используется |
|------------|--------------|
| `jq` | Скриптами установки, инспекцией JSON |
| `curl` | API-тестами |

---

## Путь A — Быстрая установка (5 мин)

```bash
git clone https://github.com/hint-shu/deep-research.git
cd deep-research
bash scripts/install.sh
```

Скрипт:

1. Копирует каждый `skills/<name>/` в `~/.claude/skills/<name>/`
2. Проверяет, что Claude Code видит их
3. Печатает следующие шаги (ключи API, тестовая команда)

После завершения скрипта переходи к [настройке API-ключей](#настройка-api-ключей).

---

## Путь B — Полная установка (20 мин)

### 1. Установить Firecrawl CLI

**macOS (Homebrew):**

```bash
brew install firecrawl
```

**Linux / WSL:**

```bash
curl -fsSL https://install.firecrawl.dev | bash
```

**Альтернатива (npm, любая платформа):**

```bash
npm install -g @mendable/firecrawl-cli
```

Проверка:

```bash
firecrawl --version
# Должно вывести: 1.12.2 (или выше)
```

### 2. Установить Tavily MCP (через Claude Code)

Tavily работает как MCP-сервер, к которому подключается Claude Code. Самый чистый путь — добавить его в твой MCP-конфиг Claude Code.

Открой `~/.claude.json` (или создай) и добавь Tavily под `mcpServers`:

```json
{
  "mcpServers": {
    "tavily": {
      "type": "http",
      "url": "https://mcp.tavily.com/mcp/?tavilyApiKey=ТВОЙ_TAVILY_КЛЮЧ_СЮДА"
    }
  }
}
```

> ⚠️ **Безопасность:** `~/.claude.json` остаётся на твоей машине. Никогда не коммить его никуда. Твой API-ключ живёт в этом файле и больше нигде в проекте.

Перезапусти Claude Code, чтобы подхватить новый MCP-сервер.

### 3. (Опционально) Установить OpenAI Codex CLI

Нужно только если хочешь cross-model канал для L2+.

```bash
# macOS
brew install openai/tap/codex

# Другие платформы: https://developers.openai.com/codex/cli
```

Войди своим ChatGPT аккаунтом (должен быть Pro для GPT-5.4):

```bash
codex auth login
```

Проверка:

```bash
codex --version
codex exec -c 'web_search="live"' --sandbox read-only \
  --skip-git-repo-check --ephemeral \
  "Какая сейчас LTS-версия Node.js?"
```

Если вернулся осмысленный ответ — Codex готов.

### 4. Клонировать и установить скиллы

```bash
git clone https://github.com/hint-shu/deep-research.git
cd deep-research
bash scripts/install.sh
```

Переходи к [настройке API-ключей](#настройка-api-ключей).

---

## Путь C — Ручная установка (30 мин)

Используй этот путь если `install.sh` падает или хочешь полный аудит.

### 1. Скопировать скиллы вручную

```bash
cp -r skills/quick-research     ~/.claude/skills/
cp -r skills/research           ~/.claude/skills/
cp -r skills/deep-research      ~/.claude/skills/
cp -r skills/expert-research    ~/.claude/skills/
cp -r skills/academic-research  ~/.claude/skills/
cp -r skills/ultra-research     ~/.claude/skills/
```

### 2. Проверить, что Claude Code их видит

Открой Claude Code в любой директории, набери `/` — должны появиться `/quick-research`, `/research`, `/deep-research`, `/expert-research`, `/academic-research`, `/ultra-research` в списке.

Если нет:

- Перезапусти Claude Code
- Проверь `~/.claude/skills/` — файлы на месте?
- Проверь, что каждый `SKILL.md` начинается с правильного frontmatter (`---\nname: ...\n`)

---

## Настройка API-ключей

### Firecrawl

**Вариант 1 — OAuth (проще):**

```bash
firecrawl config
```

Открывается браузер, залогинься или зарегистрируйся, готово.

**Вариант 2 — ручной ключ:**

1. Иди на [firecrawl.dev](https://www.firecrawl.dev), зарегистрируйся
2. Скопируй API-ключ (`fc-...`)
3. Задай его:

```bash
# В профиле шелла (~/.zshrc или ~/.bashrc):
export FIRECRAWL_API_KEY="fc-ТВОЙ_КЛЮЧ_СЮДА"
```

Или `firecrawl -k fc-ТВОЙ_КЛЮЧ ...` на каждый вызов.

Проверка:

```bash
firecrawl --status
# Должно показать: Authenticated: yes
```

### Tavily

1. Зарегистрируйся на [tavily.com](https://tavily.com)
2. Получи API-ключ (`tvly-...`)
3. Отредактируй `~/.claude.json` — замени `ТВОЙ_TAVILY_КЛЮЧ_СЮДА` на реальный ключ (см. шаг 2 Пути B)
4. Перезапусти Claude Code

Проверка: в Claude Code спроси «какие MCP-серверы подключены?» — должен быть виден `tavily`.

### Codex CLI (опционально)

```bash
codex auth login
```

Следуй flow в браузере. Env var не нужна — Codex хранит auth локально.

---

## Первый тестовый прогон

В любой директории стартуй Claude Code и запусти:

```
/quick-research последняя стабильная версия Bun
```

Ожидание: ~1 минута, короткий ответ с 3–5 цитируемыми источниками.

Если упало — прыгай в [docs/TROUBLESHOOTING.md](../TROUBLESHOOTING.md).

---

## Чеклист верификации

Запусти каждую команду, все должны завершиться успешно:

```bash
claude --version              # Claude Code установлен
firecrawl --status            # Firecrawl auth OK
firecrawl search "test" --limit 1   # Firecrawl search работает
codex --version               # (Опционально) Codex установлен
ls ~/.claude/skills/research/SKILL.md   # Скиллы скопированы
```

Изнутри Claude Code:

```
/quick-research test query    # L0 работает
mcp__tavily__tavily_search    # Tavily MCP доступен
```

---

## Обновление

```bash
cd deep-research
git pull
bash scripts/install.sh       # Перезапусти установку (идемпотентно)
```

---

## Удаление

```bash
rm -rf ~/.claude/skills/quick-research
rm -rf ~/.claude/skills/research
rm -rf ~/.claude/skills/deep-research
rm -rf ~/.claude/skills/expert-research
rm -rf ~/.claude/skills/academic-research
rm -rf ~/.claude/skills/ultra-research
```

Твои research-артефакты в `.firecrawl/research/` в отдельных проектах — твои, держи или удаляй как хочешь.

---

## Траблшутинг частых проблем установки

| Симптом | Причина | Фикс |
|---------|---------|------|
| `firecrawl: command not found` | PATH не обновился | Перезапусти терминал или `source ~/.zshrc` |
| Скиллы не в списке Claude Code | Кеш стух | Перезапусти Claude Code; проверь `~/.claude/skills/` |
| Tavily: "authentication failed" | Неверный ключ в `~/.claude.json` | Перекопируй ключ из дашборда tavily.com |
| Codex: "not authenticated" | Токен истёк | `codex auth login` заново |
| `install.sh: Permission denied` | Не хватает executable бита | `chmod +x scripts/install.sh` |

Полный траблшутинг: [docs/TROUBLESHOOTING.md](../TROUBLESHOOTING.md).
