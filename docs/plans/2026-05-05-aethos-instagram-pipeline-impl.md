# Aethos Instagram Pipeline Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Extend the existing content-pipeline-skills to autonomously generate and publish 3x/week Instagram content for @aethos.tech (2 carousels + 1 Reel).

**Architecture:** Adapt existing scout→curator→lens→writer→pulse agents for B2B/institutional mode via brand voice files, then add two new agents: `/canvas` (ChatGPT image gen) and `/publisher` (Instagram Graph API + ffmpeg Reels). A VPS cron runs the full pipeline Mon/Wed/Fri at 09h.

**Tech Stack:** Claude Code skills (SKILL.md), Instagram Graph API, OpenAI gpt-image-1, ffmpeg, Nginx (asset serving), Bash (cron scripts), VPS 148.230.73.61

**Design doc:** `docs/plans/2026-05-05-aethos-instagram-pipeline-design.md`

---

## Task 1: Aethos Brand Voice File

**Files:**
- Create: `~/.claude/skills/writer/references/aethos_brand_voice.md`

**Step 1: Create the brand voice file**

```markdown
# Aethos Tech — Brand Voice

## Identity
- **Account:** @aethos.tech
- **Language:** PT-BR
- **Person:** Third person ("A Aethos", "nossa equipe", "o time da Aethos")
- **Niche:** Software house + AI — Fortaleza/CE, atende todo o Brasil

## Audience
- **Primary:** Donos de PME que precisam automatizar processos ou digitalizar o negócio
- **Secondary:** Founders e startups que buscam parceiro técnico de confiança
- **Pain:** Perdem tempo em tarefas manuais / não sabem como usar AI no negócio

## Tone
- Autoridade sem arrogância — fala como especialista que explica de forma clara
- Confiança com calor — próximo, não frio/corporativo
- Orientado a resultado — mostra impacto, não feature
- Nunca: buzzwords vazios ("inovação disruptiva"), autoelogio excessivo, linguagem técnica sem contexto

## Content Pillars
1. **AI na prática** — como empresas usam AI para crescer (educativo → lead gen)
2. **Bastidores da Aethos** — processo, equipe, projetos reais (autoridade + humanização)
3. **Dores do empresário** — problemas comuns de gestão/tech com solução clara (conversão)

## Signature Phrases
- "Entendemos o negócio antes de escrever o código."
- "Tecnologia que resolve, não que impressiona."
- "Software que trabalha enquanto você foca no que importa."

## Never Say
- "Somos os melhores do mercado"
- "Revolucionamos" / "disruptamos"
- Anglicismos desnecessários quando existe termo em PT-BR

## CTA Patterns (lead gen focused)
- "Fale com a gente pelo link na bio."
- "Manda uma mensagem — a primeira conversa é gratuita."
- "Quer saber como isso se aplica ao seu negócio? Comenta abaixo."
- "Salva esse post — você vai precisar."

## Hashtag Set (rotate weekly)
Primary: #automacao #inteligenciaartificial #softwarehouse #desenvolvimentoweb
Secondary: #gestaoempresarial #pme #tecnologia #fortaleza #transformacaodigital
```

**Step 2: Also copy to pulse references**

```bash
cp ~/.claude/skills/writer/references/aethos_brand_voice.md \
   ~/.claude/skills/pulse/references/aethos_brand_voice.md
```

**Step 3: Commit**

```bash
cd /home/hidekina/projetos/content-pipeline-skills
git add -A
git commit -m "feat: add Aethos brand voice profile for pipeline"
```

---

## Task 2: Aethos Visual Style Guide

**Files:**
- Create: `shared/aethos-visual-style.md`

**Step 1: Create visual style file**

```markdown
# Aethos Visual Style — Canvas Agent Reference

## Brand Palette
- **Primary:** #0A1628 (dark navy)
- **Secondary:** #FFFFFF (white)
- **Accent:** #3B82F6 (blue-500)
- **Text on dark:** #F8FAFC
- **Text on light:** #0A1628
- **Dividers:** #1E3A5F

## Typography
- **Headline:** Bold, sans-serif (Inter/DM Sans)
- **Body:** Regular 16–18px, max 20 words per slide
- **Max chars per slide:** 120 (headline + body)

## Layout Rules
- Dark background (#0A1628) with white text — default for slides 1, 3, 5, 7
- Light background (#F8FAFC) with dark text — slides 2, 4, 6 (alternating)
- Aethos logo bottom-right on every slide (small, unobtrusive)
- No stock photos of generic people. Use: abstract tech patterns, code snippets, geometric shapes, real product screenshots if available.

## Slide Structure (Carousel — 7 slides)
| Slide | Role | Style |
|-------|------|-------|
| 1 | Hook — bold claim or question | Dark bg, large headline, minimal |
| 2 | Problem — audience pain | Light bg, icon + text |
| 3 | Point 1 | Dark bg, numbered, concise |
| 4 | Point 2 | Light bg, numbered, concise |
| 5 | Point 3 | Dark bg, numbered, concise |
| 6 | Proof / Example | Light bg, stat or mini-case |
| 7 | CTA | Dark bg, strong verb, link na bio |

## Prompt Template (for ChatGPT image gen)
```
Instagram carousel slide [N] of 7.
Role: [hook/problem/point/proof/CTA]
Copy (headline): "[headline text]"
Copy (body): "[body text]"
Style: flat design, tech minimal, dark navy (#0A1628) background,
white text, blue accent (#3B82F6) for highlights, bold sans-serif font,
no human faces, no generic stock images, geometric tech shapes,
Aethos logo placeholder bottom-right corner.
Format: 1080x1080px square.
```
```

**Step 2: Commit**

```bash
git add shared/aethos-visual-style.md
git commit -m "feat: add Aethos visual style guide for Canvas agent"
```

---

## Task 3: Adapt Writer — Aethos Carousel Mode

**Files:**
- Modify: `writer/SKILL.md` (add Aethos mode section)

**Step 1: Open writer/SKILL.md and add Aethos mode section after the existing Script Structure section**

Add this block:

```markdown
---

## Aethos Mode — Carousel & Reel (B2B Institutional)

Activated when brand_voice file is `aethos_brand_voice.md` or user invokes `/writer aethos`.

### Carousel Output (Mon/Wed)

Load `shared/aethos-visual-style.md` for layout rules.

Generate 7 slides following this structure:

**SLIDE 1 — HOOK**
- Bold question or counterintuitive claim (max 8 words headline)
- Subtext: 1 sentence expanding the hook (max 15 words)
- Goal: stop the scroll

**SLIDE 2 — PROBLEM**
- Name the pain the PME/founder feels
- "Se você [situação]..." framing

**SLIDES 3–5 — POINTS (numbered)**
- One concrete insight per slide
- Max 20 words each
- Use data or specific example when possible

**SLIDE 6 — PROOF**
- Mini-case or stat: "Um cliente da Aethos reduziu X em Y%"
- Or: relevant market data with source

**SLIDE 7 — CTA**
- Single action (from brand voice CTA patterns)
- "Fale com a gente pelo link na bio." is default

**Output format:**

```
## CAROUSEL — [Trend/Topic]
**Caption:** [caption PT-BR, 150–200 chars, 5 hashtags]

### Slide 1 — Hook
**Headline:** [text]
**Body:** [text]

### Slide 2 — Problem
**Headline:** [text]
**Body:** [text]

[...slides 3–7...]
```

### Reel Output (Fri)

Script adapted for slideshow (no talking head required):

- **Duration:** 20–30 seconds
- **Structure:** Hook (0–3s) → 3 points (5s each) → CTA (5s)
- **Each beat:** 1 sentence on screen (text overlay) + visual description
- Output format same as standard Writer script but with `[TEXT OVERLAY]` notation instead of speech
- Canvas will generate images per beat (5–6 total for Reel)
```

**Step 2: Commit**

```bash
git add writer/SKILL.md
git commit -m "feat(writer): add Aethos carousel and Reel mode"
```

---

## Task 4: Adapt Scout — B2B Aethos Search Mode

**Files:**
- Modify: `scout/SKILL.md` (add Aethos search sources section)

**Step 1: Add Aethos search section to Scout**

After the existing platform search section, add:

```markdown
---

## Aethos Mode — B2B Trend Search

Activated when `aethos_brand_voice.md` is present or `/scout aethos` invoked.

### Search Focus
- **Not:** general creator trends (dances, memes, viral audio)
- **Yes:** Business + tech trends relevant to PME/founders in Brazil

### Search Queries (run all, pick top 5 results)

**AI/Automation:**
- "automação para pequenas empresas 2025"
- "inteligência artificial PME Brasil"
- "IA para gestão empresarial"
- Google Trends: "chatgpt para empresas", "automação de processos"

**Software/Tech Business:**
- "transformação digital pequenas empresas"
- "software sob medida vs pronto"
- "quanto custa um sistema para empresa"

**Pain Points (LinkedIn PT-BR):**
- "gestão manual planilha problema"
- "perder tempo tarefas repetitivas"
- "controle financeiro empresa pequena"

**Sector News:**
- Startups CE/Fortaleza (Tecnologia do Nordeste, Nordeste Tech)
- Product Hunt launches relevant to SMB
- X/Twitter: #startupbrasil #pmebrasil #tecfortaleza

### Output Adjustment
- Opportunity window: B2B trends move slower — 2–4 week window (not 3 days)
- Score weight: prioritize "audience pain" over "viral potential"
- Skip: entertainment trends, creator economy, consumer-only topics
```

**Step 2: Commit**

```bash
git add scout/SKILL.md
git commit -m "feat(scout): add Aethos B2B trend search mode"
```

---

## Task 5: Create Canvas Agent

**Files:**
- Create: `canvas/SKILL.md`

**Step 1: Create canvas directory and SKILL.md**

```bash
mkdir -p canvas
```

```markdown
---
name: canvas
description: Canvas is the fifth agent in the Aethos content pipeline. It receives carousel copy or Reel beat list from Writer and generates slide images via ChatGPT (gpt-image-1), then saves them to VPS for Instagram Graph API consumption. Trigger when Writer outputs an Aethos carousel or Reel script.
---

# Canvas — Image Generation Agent

Canvas transforms Writer's structured copy into visual slide images ready for Instagram publishing.

## Pipeline Position
Scout → Curator → Lens → Writer → **Canvas** → Publisher → Pulse

## Process

### Step 1 — Parse Writer Output
- Read the carousel (7 slides) or Reel beats (5–6 frames) from Writer output
- Load `shared/aethos-visual-style.md` for brand constraints
- Build one image prompt per slide

### Step 2 — Build Image Prompts

For each slide, use this template (from visual style guide):

```
Instagram carousel slide [N] of 7.
Role: [hook/problem/point/proof/CTA]
Copy (headline): "[headline text]"
Copy (body): "[body text]"
Style: flat design, tech minimal, dark navy (#0A1628) background,
white text, blue accent (#3B82F6) for highlights, bold sans-serif font,
no human faces, no generic stock images, geometric tech shapes,
Aethos logo placeholder bottom-right corner.
Format: 1080x1080px square.
```

Alternate dark/light backgrounds per visual style guide slide structure.

### Step 3 — Generate Images via ChatGPT

Call OpenAI image generation API for each slide:
- Model: `gpt-image-1` (preferred) or `dall-e-3`
- Size: `1024x1024` (closest to 1080x1080)
- Quality: `standard`
- Output: base64 or URL

Save each image to VPS:
```bash
scp slide-N.png user@148.230.73.61:/data/aethos-content/YYYY-MM-DD/slide-N.png
```

Or via API if running on VPS directly:
```bash
/data/aethos-content/YYYY-MM-DD/slide-N.png
```

### Step 4 — Verify Public URLs

Images must be publicly accessible for Instagram Graph API.
Test each URL:
```bash
curl -I https://assets.aethostech.com.br/content/YYYY-MM-DD/slide-N.png
# Expected: HTTP 200
```

### Step 5 — Output Canvas Report

```
## CANVAS REPORT — [Date]
**Post type:** Carousel / Reel
**Slides generated:** 7
**Public URLs:**
- Slide 1: https://assets.aethostech.com.br/content/YYYY-MM-DD/slide-1.png
- Slide 2: ...
[...]
**Status:** ✅ Ready for Publisher
```

Pass this report to Publisher.

## Error Handling
- If image gen fails for a slide: retry once with simplified prompt
- If still fails: generate a text-only fallback (solid color background + text overlay via ImageMagick)
- Never pass broken URLs to Publisher — verify all before reporting ready

## Cost Tracking
Log to `/data/aethos-content/costs.log`:
```
YYYY-MM-DD | carousel | 7 images | $X.XX
```
```

**Step 2: Commit**

```bash
git add canvas/SKILL.md
git commit -m "feat: add Canvas agent for Aethos image generation"
```

---

## Task 6: Create Publisher Agent

**Files:**
- Create: `publisher/SKILL.md`
- Create: `publisher/references/instagram-api.md`

**Step 1: Create publisher directory**

```bash
mkdir -p publisher/references
```

**Step 2: Create instagram-api.md reference**

```markdown
# Instagram Graph API — Quick Reference

## Requirements
- Instagram Business or Creator account
- Facebook App with permissions:
  - `instagram_basic`
  - `instagram_content_publish`
  - `pages_read_engagement`
  - `instagram_manage_insights`
- Long-lived User Access Token (valid 60 days)
- Instagram Business Account ID

## Environment Variables (VPS)
```
INSTAGRAM_ACCESS_TOKEN=...
INSTAGRAM_ACCOUNT_ID=...
```

## Carousel Publishing Flow

```bash
# 1. Create media container for each image
curl -X POST "https://graph.facebook.com/v19.0/${ACCOUNT_ID}/media" \
  -d "image_url=https://assets.aethostech.com.br/content/DATE/slide-1.png" \
  -d "is_carousel_item=true" \
  -d "access_token=${TOKEN}"
# Returns: { "id": "CONTAINER_ID_1" }

# Repeat for all 7 slides → collect CONTAINER_IDs

# 2. Create carousel container
curl -X POST "https://graph.facebook.com/v19.0/${ACCOUNT_ID}/media" \
  -d "media_type=CAROUSEL" \
  -d "children=CONTAINER_ID_1,CONTAINER_ID_2,...,CONTAINER_ID_7" \
  -d "caption=CAPTION_TEXT" \
  -d "access_token=${TOKEN}"
# Returns: { "id": "CAROUSEL_CONTAINER_ID" }

# 3. Publish
curl -X POST "https://graph.facebook.com/v19.0/${ACCOUNT_ID}/media_publish" \
  -d "creation_id=CAROUSEL_CONTAINER_ID" \
  -d "access_token=${TOKEN}"
```

## Reel Publishing Flow

```bash
# 1. Upload video
curl -X POST "https://graph.facebook.com/v19.0/${ACCOUNT_ID}/media" \
  -d "media_type=REELS" \
  -d "video_url=https://assets.aethostech.com.br/content/DATE/reel.mp4" \
  -d "caption=CAPTION_TEXT" \
  -d "access_token=${TOKEN}"
# Returns: { "id": "REEL_CONTAINER_ID" }

# 2. Wait for processing (poll status)
curl "https://graph.facebook.com/v19.0/REEL_CONTAINER_ID?fields=status_code&access_token=${TOKEN}"
# Wait until status_code = "FINISHED"

# 3. Publish
curl -X POST "https://graph.facebook.com/v19.0/${ACCOUNT_ID}/media_publish" \
  -d "creation_id=REEL_CONTAINER_ID" \
  -d "access_token=${TOKEN}"
```

## Token Renewal
Long-lived tokens expire in 60 days. Renew via:
```bash
curl "https://graph.facebook.com/v19.0/oauth/access_token?grant_type=fb_exchange_token&client_id=APP_ID&client_secret=APP_SECRET&fb_exchange_token=CURRENT_TOKEN"
```
Set up cron to renew every 45 days.

## Rate Limits
- 25 API calls per hour per token
- Max 50 posts per 24h per account
- Images: JPEG/PNG, max 8MB, min 320px, max 1440px
```

**Step 3: Create SKILL.md**

```markdown
---
name: publisher
description: Publisher is the sixth agent in the Aethos content pipeline. It receives the Canvas Report (public image URLs + caption) and publishes to @aethos.tech Instagram via Graph API. For Reels, it first assembles the video with ffmpeg. Trigger after Canvas outputs a ready report.
---

# Publisher — Instagram Publishing Agent

Publisher takes Canvas-verified image URLs and posts to Instagram via the Graph API.

## Pipeline Position
Scout → Curator → Lens → Writer → Canvas → **Publisher** → Pulse

## Environment (VPS)
- `INSTAGRAM_ACCESS_TOKEN` — long-lived token (see `references/instagram-api.md`)
- `INSTAGRAM_ACCOUNT_ID` — Business Account ID
- Images available at: `/data/aethos-content/YYYY-MM-DD/`
- Public base URL: `https://assets.aethostech.com.br/content/`

## Process

### Carousel (Mon/Wed)

Load canvas report → extract 7 image URLs + caption.

Run carousel publish flow from `references/instagram-api.md`:
1. Create container per slide (7 API calls)
2. Create carousel container
3. Publish
4. Log result to `/data/aethos-content/publish-log.jsonl`

### Reel (Fri)

**Step 1 — Assemble video with ffmpeg**

Canvas provides 5–6 frame images + Reel beat copy.

```bash
# Create input list
for i in 1 2 3 4 5; do
  echo "file '/data/aethos-content/DATE/reel-frame-$i.png'" >> /tmp/reel-input.txt
  echo "duration 5" >> /tmp/reel-input.txt
done

# Select random royalty-free track
TRACK=$(ls /data/aethos-music/*.mp3 | shuf -n1)

# Assemble
ffmpeg -f concat -safe 0 -i /tmp/reel-input.txt \
  -i "$TRACK" \
  -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,fps=30" \
  -af "afade=t=out:st=25:d=5" \
  -t 30 \
  -c:v libx264 -c:a aac \
  /data/aethos-content/DATE/reel.mp4
```

**Step 2 — Upload and publish Reel** (see instagram-api.md Reel flow)

### Publish Log Format

Append to `/data/aethos-content/publish-log.jsonl`:
```json
{"date":"YYYY-MM-DD","type":"carousel|reel","post_id":"IG_POST_ID","url":"https://instagram.com/p/POST_ID","status":"published","caption_preview":"first 50 chars..."}
```

### Error Handling
- API error → retry once after 60s
- Video processing timeout (>10min) → alert via ARIA task
- Token expired → run renewal script + alert

## Post-Publish
Output for Pulse:
```
## PUBLISHER REPORT — [Date]
**Type:** Carousel / Reel
**Post ID:** [IG_POST_ID]
**URL:** https://instagram.com/p/[POST_ID]
**Published at:** HH:MM
**Status:** ✅ Published
```
```

**Step 4: Commit**

```bash
git add publisher/SKILL.md publisher/references/instagram-api.md
git commit -m "feat: add Publisher agent for Instagram Graph API posting"
```

---

## Task 7: VPS Infrastructure Setup

**Files:**
- Create: `scripts/vps-setup.sh` (run once on VPS)

**Step 1: Create setup script**

```bash
#!/usr/bin/env bash
# Run on VPS: bash scripts/vps-setup.sh

set -e

# Create content directories
mkdir -p /data/aethos-content
mkdir -p /data/aethos-music

# Install ffmpeg if not present
if ! command -v ffmpeg &>/dev/null; then
  apt-get update && apt-get install -y ffmpeg
fi

# Download royalty-free music tracks (Pixabay/ccMixter)
# Replace URLs with actual royalty-free tracks
echo "Download 3-5 royalty-free background tracks to /data/aethos-music/"
echo "Sources: pixabay.com/music, freemusicarchive.org"

# Nginx config for asset serving
cat > /etc/nginx/sites-available/aethos-assets << 'EOF'
server {
    listen 80;
    server_name assets.aethostech.com.br;

    location /content/ {
        alias /data/aethos-content/;
        autoindex off;
        add_header Cache-Control "public, max-age=86400";
    }
}
EOF

ln -sf /etc/nginx/sites-available/aethos-assets /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx

echo "✅ VPS setup complete"
echo "Next: point DNS assets.aethostech.com.br → 148.230.73.61"
echo "Next: set up SSL with certbot for assets.aethostech.com.br"
```

**Step 2: Run on VPS**

```bash
scp scripts/vps-setup.sh user@148.230.73.61:/tmp/
ssh user@148.230.73.61 "bash /tmp/vps-setup.sh"
```

**Step 3: SSL for assets subdomain**

```bash
ssh user@148.230.73.61 "certbot --nginx -d assets.aethostech.com.br"
```

**Step 4: Commit**

```bash
git add scripts/vps-setup.sh
git commit -m "feat: add VPS setup script for asset serving"
```

---

## Task 8: Cron Pipeline Script

**Files:**
- Create: `scripts/run-pipeline-aethos.sh`

**Step 1: Create pipeline runner script**

```bash
#!/usr/bin/env bash
# Aethos Instagram pipeline runner
# Triggered by cron Mon/Wed/Fri at 09h

set -e

DATE=$(date +%Y-%m-%d)
DAY=$(date +%u)  # 1=Mon, 3=Wed, 5=Fri
LOG="/data/aethos-content/pipeline.log"

echo "[${DATE}] Pipeline start — day ${DAY}" >> "$LOG"

# Determine post type
if [ "$DAY" = "5" ]; then
  POST_TYPE="reel"
else
  POST_TYPE="carousel"
fi

# Run Claude Code pipeline
# This triggers: scout → curator → lens → writer (aethos) → canvas → publisher
claude --print "/scout aethos" \
  | claude --print "/curator" \
  | claude --print "/lens aethos" \
  | claude --print "/writer aethos ${POST_TYPE}" \
  | claude --print "/canvas" \
  | claude --print "/publisher" >> "$LOG" 2>&1

echo "[${DATE}] Pipeline end" >> "$LOG"
```

**Step 2: Set executable + add cron**

```bash
chmod +x scripts/run-pipeline-aethos.sh

# Add to crontab on VPS:
# 0 9 * * 1,3,5 /path/to/scripts/run-pipeline-aethos.sh
ssh user@148.230.73.61 "echo '0 9 * * 1,3,5 /home/user/content-pipeline-skills/scripts/run-pipeline-aethos.sh' | crontab -"
```

**Step 3: Test dry run**

```bash
bash scripts/run-pipeline-aethos.sh --dry-run
# Expected: log entries without actual API calls
```

**Step 4: Commit**

```bash
git add scripts/run-pipeline-aethos.sh
git commit -m "feat: add cron pipeline runner for Aethos Instagram"
```

---

## Task 9: Adapt Pulse — Instagram Insights

**Files:**
- Modify: `pulse/SKILL.md` (add Instagram Insights section)

**Step 1: Add Instagram Insights section to Pulse**

After the existing analysis section, add:

```markdown
---

## Aethos Mode — Instagram Insights Analysis

Activated when `aethos_brand_voice.md` is present or `/pulse aethos` invoked.

### Data Sources

Read from Instagram Graph API Insights:
```bash
curl "https://graph.facebook.com/v19.0/${POST_ID}/insights?metric=reach,impressions,saved,shares,comments_count,likes&access_token=${TOKEN}"
```

Read publish log: `/data/aethos-content/publish-log.jsonl`

### Metrics to Track

| Metric | Good | Great |
|--------|------|-------|
| Reach | >500 | >2000 |
| Saves | >5% reach | >10% reach |
| Profile visits | >3% reach | >8% reach |
| Link clicks (bio) | >1% reach | >3% reach |

### Feedback to Scout

After analyzing last 3 posts, output:

```
## PULSE FEEDBACK — [Week]
**Top performer:** [post topic] — [key metric]
**Underperformer:** [post topic] — [what was weak]
**Content pillar winning:** [pillar name]
**Scout direction next week:** [specific topic angle to double down on]
**Avoid:** [topic/format that underperformed]
```

Scout reads this feedback at start of next cycle.
```

**Step 2: Commit**

```bash
git add pulse/SKILL.md
git commit -m "feat(pulse): add Instagram Insights analysis for Aethos mode"
```

---

## Task 10: Instagram API Setup (One-Time)

This task is done manually by César.

**Step 1: Convert @aethos.tech to Business/Creator**

In Instagram app: Settings → Account → Switch to Professional Account → Business

**Step 2: Create Facebook App**

1. Go to developers.facebook.com → Create App → Business
2. Add product: Instagram Graph API
3. Add permissions: `instagram_basic`, `instagram_content_publish`, `pages_read_engagement`, `instagram_manage_insights`
4. Generate User Access Token
5. Exchange for Long-Lived Token (60 days):
```bash
curl "https://graph.facebook.com/v19.0/oauth/access_token?grant_type=fb_exchange_token&client_id=APP_ID&client_secret=APP_SECRET&fb_exchange_token=SHORT_LIVED_TOKEN"
```

**Step 3: Get Instagram Account ID**

```bash
curl "https://graph.facebook.com/v19.0/me/accounts?access_token=TOKEN"
# Find the page ID, then:
curl "https://graph.facebook.com/v19.0/PAGE_ID?fields=instagram_business_account&access_token=TOKEN"
```

**Step 4: Save secrets to VPS**

```bash
ssh user@148.230.73.61
echo "INSTAGRAM_ACCESS_TOKEN=xxx" >> /etc/environment
echo "INSTAGRAM_ACCOUNT_ID=xxx" >> /etc/environment
```

**Step 5: Sync skills to Claude**

```bash
cd /home/hidekina/projetos/content-pipeline-skills
bash sync-pipeline.sh
```

---

## Task 11: End-to-End Test

**Step 1: Run Scout manually (Aethos mode)**

```bash
claude "/scout aethos"
# Expected: list of 5–8 B2B tech trends with scores
```

**Step 2: Run Writer (carousel)**

```bash
claude "/writer aethos carousel"
# Expected: 7-slide copy with headlines, body, caption
```

**Step 3: Test Canvas (1 slide)**

```bash
claude "/canvas --test slide-1-only"
# Expected: image generated, saved to /data/aethos-content/test/, public URL returns HTTP 200
```

**Step 4: Test Publisher (dry run)**

```bash
claude "/publisher --dry-run"
# Expected: API calls logged but not executed, no post created
```

**Step 5: Full pipeline smoke test**

```bash
bash scripts/run-pipeline-aethos.sh
# Check: publish-log.jsonl has new entry
# Check: Instagram post visible on @aethos.tech
```

---

## Checklist Before Go-Live

- [ ] @aethos.tech converted to Business/Creator account
- [ ] Facebook App created, permissions approved
- [ ] Long-lived token saved to VPS `/etc/environment`
- [ ] `assets.aethostech.com.br` DNS pointing to VPS, SSL active
- [ ] Nginx serving `/data/aethos-content/` → HTTP 200
- [ ] ffmpeg installed on VPS
- [ ] 3–5 royalty-free music tracks in `/data/aethos-music/`
- [ ] Canvas generates and uploads images successfully
- [ ] Publisher dry-run passes
- [ ] Cron added to VPS
- [ ] `sync-pipeline.sh` run — all new skills in `~/.claude/skills/`
