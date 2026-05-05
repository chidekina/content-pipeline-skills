# Aethos Instagram Pipeline — Design

**Date:** 2026-05-05  
**Status:** Approved  
**Scope:** Extend content-pipeline-skills to automate @aethos.tech Instagram posts

---

## Context

The existing content pipeline (scout→curator→lens→writer→brief→pulse) was built for personal creators. This design adapts and extends it for Aethos Tech's institutional Instagram account (`@aethos.tech`), targeting PME owners and founders/startups in Brazil.

---

## Goals

- **Primary (70%):** Lead generation — content that converts followers into commercial contacts
- **Secondary (30%):** Authority/brand — position Aethos as AI + software reference in CE/BR
- **Frequency:** 3x/week (Mon/Wed: carousel, Fri: Reel)
- **Automation:** Fully autonomous — pipeline runs, generates, and publishes without human approval

---

## Architecture

```
/scout → /curator → /lens → /writer (aethos mode)
                                    ↓
                              /canvas (new)
                              ChatGPT generates slide images
                                    ↓
                              /publisher (new)
                              Instagram Graph API posts
                                    ↓
                              /pulse → feedback → /scout
```

### Cron Schedule (VPS: 148.230.73.61)

| Day | Time | Format |
|-----|------|--------|
| Monday | 09h | Carousel (7 slides) |
| Wednesday | 09h | Carousel (7 slides) |
| Friday | 09h | Reel (slideshow via ffmpeg) |

---

## Adapted Agents

| Agent | Change |
|-------|--------|
| Scout | Search B2B trends: AI, automation, management, software house BR/CE |
| Curator | Filter by lead gen potential for PME/founders |
| Lens | Bootstrap with sector benchmarks (no history initially) |
| Writer | Aethos mode → carousel copy (7 slides) or Reel script |

Brand voice loaded from `~/.claude/skills/writer/references/aethos_brand_voice.md` — institutional PT-BR, third person, authority + trust tone.

---

## New Agents

### `/canvas` — Image Generation

1. Receives Writer output (7-slide copy)
2. Builds structured prompt per slide → calls ChatGPT (gpt-image-1 or dall-e-3)
3. Visual style: Aethos palette (dark blue + white + accent), bold sans-serif, minimal tech aesthetic
4. Saves images to VPS: `/data/aethos-content/YYYY-MM-DD/slide-N.png`
5. Serves publicly via: `https://assets.aethostech.com.br/content/...`

**Cost estimate:** ~$0.08/image × 7 slides × 3 posts/week ≈ $1.70/week

### `/publisher` — Instagram Publishing

**Carousel (Mon/Wed):**
1. Upload each image → `POST /media` (container per slide)
2. Create carousel container with all IDs
3. Publish → `POST /media_publish`
4. Caption from Writer (with CTAs + hashtags)

**Reel (Fri):**
1. ffmpeg assembles slideshow: images + text overlay + royalty-free track
2. Upload video → `POST /media` (type=REELS)
3. Publish with caption

---

## New Files

```
content-pipeline-skills/
  canvas/
    SKILL.md
  publisher/
    SKILL.md
    references/
      instagram-api.md
  writer/references/
    aethos_brand_voice.md
  shared/
    aethos-visual-style.md
```

---

## Technical Requirements

### Instagram Graph API
- `@aethos.tech` must be Business or Creator account
- Facebook App with permissions: `instagram_basic`, `instagram_content_publish`, `pages_read_engagement`
- Long-lived token (60 days) with auto-renewal cron
- Token stored as VPS secret

### VPS Setup
- Nginx serving `/data/aethos-content/` as public assets
- ffmpeg installed
- Royalty-free music tracks in `/data/aethos-music/`
- Cron via ARIA scheduler

### OpenAI
- API key with access to `gpt-image-1` or `dall-e-3`

---

## Data Flow

```
scout ──► curator ──► lens ──► writer ──► canvas ──► publisher
                                              ↑
                                    aethos_brand_voice.md
                                    aethos-visual-style.md
```

Pulse reads Instagram Insights API post-publish → feeds engagement data back to Scout for next cycle.
