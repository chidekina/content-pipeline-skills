# Content Pipeline Skills — Claude Code

A complete content marketing pipeline built as Claude Code skills. Six agents that work together to discover trends, curate, ideate, write scripts, plan the week, and continuously improve through data.

## Pipeline Flow

```
/scout → /curator → /lens → /writer → /brief → [Human records & publishes] → /pulse → /scout
```

## Agents

| Agent | Role | Command |
|-------|------|---------|
| **Scout** | Discovers trends across YouTube Shorts, TikTok, Instagram, Twitter/X, Google Trends, and Reddit. Tags production complexity and competitor saturation. | `/scout` |
| **Curator** | Scores each trend on 6 criteria (engagement, audience fit, shelf life, originality, production complexity, opportunity window). Selects top 5. | `/curator` |
| **Lens** | Refracts each trend into 6 creative angles: Educational, Hot Take, Personal Story, How-to, Trend Reaction, and Collab/Duet. Ranks by execution risk. | `/lens` |
| **Writer** | Writes a complete, production-ready script: hook, development, CTA, thumbnail copy, B-roll shot list, SEO caption, and pinned comment. | `/writer` |
| **Brief** | Consolidates all scripts into a prioritized weekly editorial calendar with effort estimates and a pre-recording checklist. | `/brief` |
| **Pulse** | Weekly performance review: engagement analysis, angle breakdown, competitor benchmarking, historical analytics log, and editorial calendar for next week. Feeds recommendations back to Scout. | `/pulse` |

## First Use — Onboarding

Run `/scout` for the first time. It will detect that no brand profile exists and conduct a short onboarding interview (5 blocks, one at a time) to capture:

- Creator identity & niche
- Target audience & pain points
- Voice, tone & signature phrases
- Platforms, posting frequency & content pillars
- References & content constraints

The profile is saved to `~/.claude/skills/writer/references/brand_voice.md` and used automatically by all agents from that point on.

## Instalação

### Pré-requisitos

1. **Node.js 18+** — [nodejs.org/en/download](https://nodejs.org/en/download)
2. **Claude Code** — instale via terminal:
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```
3. **Conta Anthropic** com acesso à API — [console.anthropic.com](https://console.anthropic.com)

### Instalar os skills

**Opção A — via Git (recomendado)**
```bash
# Clone o repositório
git clone https://github.com/chidekina/content-pipeline-skills.git

# Copie os 6 skills para a pasta de skills do Claude Code
cp -r content-pipeline-skills/scout   ~/.claude/skills/
cp -r content-pipeline-skills/curator ~/.claude/skills/
cp -r content-pipeline-skills/lens    ~/.claude/skills/
cp -r content-pipeline-skills/writer  ~/.claude/skills/
cp -r content-pipeline-skills/brief   ~/.claude/skills/
cp -r content-pipeline-skills/pulse   ~/.claude/skills/
```

**Opção B — um único comando**
```bash
git clone https://github.com/chidekina/content-pipeline-skills.git && \
  for skill in scout curator lens writer brief pulse; do
    cp -r content-pipeline-skills/$skill ~/.claude/skills/
  done
```

> **Windows (WSL ou Git Bash):** use os mesmos comandos acima.
> **macOS / Linux:** funciona direto.

### Verificar instalação

Abra o Claude Code e rode:
```
/skills
```
Você deve ver `scout`, `curator`, `lens`, `writer`, `brief` e `pulse` na lista.

## Weekly Workflow

```
Monday morning:
  /scout          → Discover this week's trends

Monday afternoon:
  /curator        → Select top 5 trends

Monday evening:
  /lens           → Generate 6 angles per trend

Tuesday:
  /writer         → Write scripts for selected trend + angle combos
  /brief          → Build the week's editorial plan

Tue–Sat:
  [Record & publish following Brief's calendar]

Friday:
  /pulse          → Review performance, update analytics log, calibrate next Scout
```

## Feedback Loop

Pulse saves recommendations to `~/.claude/skills/pulse/references/last_feedback.md`. Scout reads this file on every run to calibrate searches — meaning the pipeline gets smarter every week based on what actually performed.

## File Structure

```
skill-name/
├── SKILL.md              — Agent instructions
└── references/
    └── pipeline.md       — Shared output format specs
```

Key runtime files (created automatically):
```
~/.claude/skills/writer/references/brand_voice.md     — Creator profile (onboarding)
~/.claude/skills/pulse/references/last_feedback.md    — Weekly Scout calibration
~/.claude/skills/pulse/references/analytics_log.md    — Cumulative performance data
```
