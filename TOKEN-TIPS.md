# Token Optimization Guide — Content Pipeline

Guia prático para reduzir o consumo de tokens ao usar os 7 agentes do pipeline.

---

## Regra geral: uma sessão por agente

Abra uma sessão nova para cada agente. Cole o output do anterior e rode o comando. Acumular agentes na mesma sessão carrega todo o histórico no contexto de cada resposta.

---

## Modelo por agente

Mude o modelo antes de cada sessão com `/model`. Nem todo agente precisa do mesmo nível.

| Agente | Modelo | Comando |
|--------|--------|---------|
| `/scout` | Sonnet (padrão) | — |
| `/curator` | Haiku | `/model claude-haiku-4-5-20251001` |
| `/lens` | Sonnet (padrão) | — |
| `/writer` | Sonnet (padrão) | — |
| `/brief` | Haiku | `/model claude-haiku-4-5-20251001` |
| `/pulse` | Haiku | `/model claude-haiku-4-5-20251001` |

Curator, Brief e Pulse executam tarefas estruturadas com input definido — Haiku é suficiente e custa ~20x menos que Opus.

---

## Por agente

### /scout

**Limite as plataformas.** O Scout busca 6 por padrão. Se você já sabe onde seu público está, instrua antes:
> "Pesquise só YouTube Shorts, Instagram e Reddit"

**Passe o feedback do Pulse diretamente.** Em vez de deixar o Scout ler o arquivo automaticamente, cole o bloco de recomendações na abertura:
> `/scout` + "Recomendações da semana passada: [cole o bloco do Pulse]"

---

### /lens

**Peça só os ângulos que você usa.** O Lens gera 6 por padrão. Se você só usa Educational e How-to:
> "Gere apenas os ângulos Educational e How-to para cada trend"

Corta a resposta pela metade.

---

### /writer

**Entre com tudo na primeira mensagem.** O Writer pergunta trend, ângulo e plataforma se não forem especificados — cada pergunta é um turno extra.

- Cole o bloco do Lens
- Indique o ângulo escolhido
- Informe a plataforma

Tudo em uma mensagem → zero rodadas de coleta.

**Um script por sessão.** Se precisar de mais scripts, abra uma sessão nova para cada um.

**Não itere na mesma sessão.** Se o script precisar de ajuste, feche a sessão, abra uma nova, cole o script e dê a instrução específica de revisão.

---

### /pulse

**Cole os dados formatados na primeira mensagem.** O Pulse pede em etapas se não receber logo. Use este template toda semana antes de abrir o agente:

```
Vídeo 1: [título] | [plataforma] | [views] | [likes] | [saves] | [shares]
Vídeo 2: [título] | [plataforma] | [views] | [likes] | [saves] | [shares]
```

Zero rodadas de coleta.

---

### /curator e /brief

Apenas cole o output do agente anterior e rode o comando. Não adicione contexto extra — eles já têm tudo que precisam na estrutura recebida.

---

## brand_voice.md — faça backup

O onboarding do Scout (5 blocos de perguntas) gera o `brand_voice.md`. Se o arquivo sumir ao reinstalar ou trocar de máquina, o processo roda do zero — cerca de 10 turnos desperdiçados.

Guarde uma cópia do arquivo em qualquer lugar (Google Drive, nota no celular).

Localização: `~/.claude/skills/writer/references/brand_voice.md`

---

## Resumo rápido

| Situação | O que fazer |
|----------|------------|
| Agente lento / caro | Troque para Haiku (Curator, Brief, Pulse) |
| Scout buscando demais | Limite para 2–3 plataformas |
| Writer fazendo perguntas | Entre com trend + ângulo + plataforma na primeira mensagem |
| Pulse pedindo dados | Use o template de métricas antes de abrir |
| Script pedindo revisão | Feche e abra sessão nova |
| Onboarding sumiu | Restaure o brand_voice.md do backup |
