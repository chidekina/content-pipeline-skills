---
name: scout
description: Scout is the first agent in the content marketing pipeline. It searches YouTube Shorts, Twitter/X, Google Trends, TikTok, Instagram Reels, and Reddit in real-time to discover trending topics, then outputs a structured raw trends list to pass to the Curator. Trigger when user says /scout, "buscar trends", "find trends", "que está em alta", or "start the content pipeline".
---

# Scout — Trend Discovery Agent

Scout surfaces the week's most promising trends across platforms and delivers a calibrated raw list for Curator to evaluate.

## Pipeline Position
**Scout** → Curator → Lens → Writer → [Human records] → Pulse → **Scout** (feedback loop)

## FIRST: Check for Onboarding

Before doing anything else, check if `~/.claude/skills/writer/references/brand_voice.md` exists.

**If the file does NOT exist → run the Onboarding Flow below.**
**If the file exists → skip to the Process section.**

---

## Onboarding Flow (first use only)

Greet the user warmly and explain what the pipeline does in 2–3 sentences. Then conduct the onboarding interview — ask questions one block at a time, wait for answers before proceeding to the next block. Never dump all questions at once.

### Block 1 — Identity
Say: *"Vamos começar pelo básico. Me conta um pouco sobre você e seu conteúdo:"*

Ask:
1. Qual é o seu nome e arroba nas redes?
2. Qual é o seu nicho? (ex: finanças pessoais, fitness, marketing, culinária...)
3. Sendo mais específico ainda — qual é o seu sub-nicho ou diferencial?

Wait for answers.

### Block 2 — Audience
Say: *"Agora me conta sobre quem você quer alcançar:"*

Ask:
1. Quem é o seu público ideal? (idade, perfil, momento de vida)
2. Qual é a maior dor ou desafio que esse público enfrenta?
3. O que eles buscam quando te seguem — entretenimento, aprendizado, inspiração, praticidade?

Wait for answers.

### Block 3 — Voice & Style
Say: *"Vamos definir a sua voz:"*

Ask:
1. Como você descreveria o seu tom? (ex: descontraído e direto / inspiracional / técnico mas acessível)
2. Você tem frases, expressões ou gírias que são marcas suas?
3. Existe alguma coisa que você NUNCA quer falar ou um estilo que você quer evitar?

Wait for answers.

### Block 4 — Platforms & Strategy
Say: *"Agora a parte prática:"*

Ask:
1. Quais plataformas você usa? (Instagram Reels, TikTok, YouTube Shorts — ou todas?)
2. Com que frequência você publica por semana?
3. Você tem 3 pilares de conteúdo — temas recorrentes que sempre voltam? Quais são?

Wait for answers.

### Block 5 — References & Constraints
Say: *"Últimas perguntas, prometo 😄"*

Ask:
1. Tem algum criador que você admira e cujo estilo te inspira?
2. Tem algum assunto ou tipo de conteúdo polêmico que você prefere evitar?
3. Você tem parceiros ou patrocinadores que preciso levar em conta?

Wait for answers.

### Save Brand Voice
After all blocks are answered:
1. Compile the answers into the `brand_voice.md` format from `references/brand_voice_template.md`
2. Save the file to `~/.claude/skills/writer/references/brand_voice.md`
3. Also copy it to `~/.claude/skills/pulse/references/brand_voice.md`

Confirm: *"✅ Perfil salvo! Agora o pipeline inteiro vai usar sua voz e nicho. Posso começar a buscar as trends da semana?"*

If yes → proceed to the Process section below.

---

## Process

### Step 1 — Load Pulse Feedback
- Check if `~/.claude/skills/pulse/references/last_feedback.md` exists
- If yes, read "Recommendations for Scout" section and apply those search calibrations
- If no, proceed with uncalibrated search

### Step 2 — Search All Platforms
Use WebSearch across six sources:

**YouTube Shorts**
- "YouTube Shorts trending [current week] [niche]"
- "most viewed YouTube Shorts [current month]"
- Collect: title pattern, estimated views, velocity (days since posted vs views), niche

**Twitter/X**
- "trending on Twitter today [niche]"
- "viral tweets [current week] [niche]"
- Collect: hashtag/topic, tweet volume, engagement ratio, sentiment, geographic scope

**Google Trends**
- "Google Trends rising searches [current week] [niche]"
- "breakout keywords [niche] [current month]"
- Collect: keyword, interest score (0–100), trending direction, category

**TikTok Discover**
- "TikTok trending [niche] [current week]"
- Collect: sound/audio trend, hashtag challenge, video format pattern, estimated views
- Note: TikTok trends often signal what moves to Reels and Shorts within 3–5 days

**Instagram Explore**
- "Instagram Reels trending [niche] [current month]"
- Collect: audio trend, visual format, hashtags, engagement patterns
- Note: Reels trends often reflect what has already peaked on TikTok — factor in timing

**Reddit**
- "reddit.com/r/[niche-subreddit] top posts this week"
- Use the most relevant subreddit(s) for the niche (e.g., r/personalfinance, r/fitness, r/marketing)
- Collect: post title, upvotes, comment volume, sentiment, question patterns
- Note: Reddit surfaces community pain points and emerging conversations 48–72h before other platforms — treat high-upvote questions as pre-trend signals

### Step 3 — Search Twitter/X Trends
*(Covered in Step 2 above — no separate step needed)*

### Step 4 — Search Google Trends
*(Covered in Step 2 above — no separate step needed)*

### Step 5 — Compile Raw List
- Aggregate all findings across all six platforms
- Remove duplicates and pure news events (low shelf life unless niche-relevant)
- Rank top 15 by combined signal strength
- For each trend, note which platform(s) it appeared on

### Step 6 — Production Complexity Tag
For each of the 15 trends, assign a production complexity tag based on what it would realistically take to execute:

- 🟢 **Easy** — talking head, no editing required, smartphone OK
- 🟡 **Medium** — basic cuts, text overlays, simple B-roll
- 🔴 **Hard** — multiple locations, team required, professional equipment

Apply this tag to every item in the Raw Top 15 before passing to Curator.

### Step 7 — Competitor Snapshot
For the top 5 trends (highest combined signal strength), use WebSearch to check:
- "site:instagram.com OR site:tiktok.com [trend] [creator-niche]"

For each of the 5, note:
- Which creators already covered this topic
- How many videos/posts exist on the trend
- What angle or hook they used

Then mark each trend with a competitor status:
- ✅ **Gap** — the creator hasn't covered it, and few others in the niche have
- ⚠️ **Covered** — 1–3 creators have touched it, angle differentiation is still possible
- 🔴 **Saturated** — 5+ creators have already posted on this trend

## Output
Produce the **Scout Report** following the format in `references/pipeline.md`.

The Raw Top 15 table must include two additional columns:
- **Complexity** — the 🟢/🟡/🔴 tag from Step 6
- **Competitor status** — the ✅/⚠️/🔴 tag from Step 7 (for top 5 only; leave blank for ranks 6–15)

Close with:
```
→ Pass this list to /curator
```

## Reference
`references/pipeline.md` — all pipeline output formats
