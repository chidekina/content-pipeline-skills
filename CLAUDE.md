# content-pipeline-skills

Pipeline de marketing de conteúdo construído como Claude Code skills. 7 agentes que trabalham juntos para descobrir tendências, curar, escrever, planejar e melhorar continuamente.

## Pipeline
```
/scout → /curator → /lens → /writer → /brief → [publica] → /pulse → /scout
```

## Skills
| Skill | Arquivo | Função |
|-------|---------|--------|
| `/scout` | `scout/` | Descoberta de tendências e oportunidades de conteúdo |
| `/curator` | `curator/` | Curadoria e seleção do que produzir |
| `/lens` | `lens/` | Análise de performance de conteúdo publicado |
| `/writer` | `writer/` | Geração de scripts e textos |
| `/brief` | `brief/` | Planejamento semanal de conteúdo |
| `/pulse` | `pulse/` | Análise de dados pós-publicação |
| `/update-profile` | `update-profile/` | Atualização de voz e perfil da marca |

## Structure
```
<skill-name>/
  SKILL.md       # definição da skill (frontmatter + instruções)
shared/          # utilitários compartilhados entre skills
```

## Usage
Skills são carregadas automaticamente pelo Claude Code. Invocar com `/skill-name`.

## Notes
- Ver `TOKEN-TIPS.md` para otimização de contexto
- Ver `CHANGELOG.md` para histórico de versões
- `sync-pipeline.sh` — sincroniza skills com `~/.claude/skills/`
