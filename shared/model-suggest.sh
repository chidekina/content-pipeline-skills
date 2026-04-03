#!/bin/bash
# model-suggest.sh — Model routing hint for Content Pipeline users
# Fires on every prompt (UserPromptSubmit hook) and suggests the right model tier.
#
# Install:
#   1. Copy this file to ~/.claude/hooks/model-suggest.sh
#   2. chmod +x ~/.claude/hooks/model-suggest.sh
#   3. Add to ~/.claude/settings.json under hooks > UserPromptSubmit (see TOKEN-TIPS.md)

prompt=$(cat)

# ── Haiku suggestions: structured agents that don't need deep reasoning
haiku_patterns=(
  "/curator"
  "/brief"
  "/pulse"
  "curar trends"
  "curate trends"
  "plano da semana"
  "editorial da semana"
  "review semanal"
  "weekly review"
  "o que performou"
  "analisar resultados"
  "pontuar trends"
  "score.*trend"
)

for pattern in "${haiku_patterns[@]}"; do
  if echo "$prompt" | grep -qiE "$pattern"; then
    echo "💡 Este agente roda bem com Haiku (mais barato). Troque antes de continuar: /model claude-haiku-4-5-20251001"
    exit 0
  fi
done

# ── Sonnet reminder: creative agents that need quality
sonnet_patterns=(
  "/scout"
  "/lens"
  "/writer"
  "buscar trends"
  "find trends"
  "gerar ângulos"
  "generate angles"
  "escrever roteiro"
  "write script"
)

for pattern in "${sonnet_patterns[@]}"; do
  if echo "$prompt" | grep -qiE "$pattern"; then
    echo "✅ Agente criativo — Sonnet é o modelo certo para esta tarefa."
    exit 0
  fi
done

exit 0
