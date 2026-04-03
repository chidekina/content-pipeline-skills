# Content Pipeline Skills — Claude Code

Um pipeline completo de marketing de conteúdo construído como skills do Claude Code. Seis agentes que trabalham juntos para descobrir trends, curar, criar roteiros, planejar a semana e melhorar continuamente com base nos dados.

## Fluxo do Pipeline

```
/scout → /curator → /lens → /writer → /brief → [Você grava e publica] → /pulse → /scout
```

## Agentes

| Agente | Função | Comando |
|--------|--------|---------|
| **Scout** | Descobre trends no YouTube Shorts, TikTok, Instagram, Twitter/X, Google Trends e Reddit. Classifica complexidade de produção e saturação de concorrentes. | `/scout` |
| **Curator** | Pontua cada trend em 6 critérios (engajamento, fit com audiência, vida útil, originalidade, complexidade, janela de oportunidade) e seleciona as top 5. | `/curator` |
| **Lens** | Refrata cada trend em 6 ângulos criativos: Educacional, Hot Take, História Pessoal, How-to, Reação à Trend e Collab/Duet. Ordena por risco de execução. | `/lens` |
| **Writer** | Escreve o roteiro completo e pronto para gravar: hook, desenvolvimento, CTA, texto da thumbnail, lista de B-roll, legenda SEO e comentário fixado. | `/writer` |
| **Brief** | Consolida todos os roteiros em um calendário editorial priorizado com estimativa de esforço e checklist pré-gravação. | `/brief` |
| **Pulse** | Review semanal de performance: análise de engajamento, breakdown por ângulo, benchmarking de concorrentes, log histórico e calendário para a próxima semana. Alimenta o Scout com recomendações. | `/pulse` |

## Primeira Vez — Onboarding

Na primeira vez que você rodar `/scout`, o agente vai detectar que não existe um perfil de marca e vai conduzir uma entrevista rápida (5 blocos, um por vez) para capturar:

- Identidade e nicho do criador
- Público-alvo e principais dores
- Voz, tom e expressões características
- Plataformas, frequência de postagem e pilares de conteúdo
- Referências e restrições de conteúdo

O perfil é salvo em `~/.claude/skills/writer/references/brand_voice.md` e usado automaticamente por todos os agentes a partir daí.

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

> **Windows:** use o WSL (Windows Subsystem for Linux) ou Git Bash com os mesmos comandos acima.
> **macOS / Linux:** funciona direto no terminal.

### Verificar instalação

Abra o Claude Code e rode:
```
/skills
```
Você deve ver `scout`, `curator`, `lens`, `writer`, `brief` e `pulse` na lista.

## Rotina Semanal

```
Segunda de manhã:
  /scout     → Descobrir as trends da semana

Segunda à tarde:
  /curator   → Selecionar as top 5 trends

Segunda à noite:
  /lens      → Gerar 6 ângulos por trend

Terça:
  /writer    → Escrever os roteiros (trend + ângulo escolhido)
  /brief     → Montar o plano editorial da semana

Ter–Sáb:
  [Gravar e publicar seguindo o calendário do Brief]

Sexta:
  /pulse     → Analisar performance, atualizar log histórico, calibrar o próximo Scout
```

## Loop de Melhoria Contínua

O Pulse salva recomendações em `~/.claude/skills/pulse/references/last_feedback.md`. O Scout lê esse arquivo em toda execução para calibrar as buscas — o pipeline fica mais inteligente a cada semana com base no que realmente performou.

## Estrutura de Arquivos

```
skill-name/
├── SKILL.md              — Instruções do agente
└── references/
    └── pipeline.md       — Formatos de output compartilhados entre os agentes
```

Arquivos gerados automaticamente em tempo de uso:
```
~/.claude/skills/writer/references/brand_voice.md     — Perfil de marca (onboarding)
~/.claude/skills/pulse/references/last_feedback.md    — Calibração semanal do Scout
~/.claude/skills/pulse/references/analytics_log.md    — Histórico acumulado de performance
```
