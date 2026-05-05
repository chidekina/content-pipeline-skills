---
name: canvas
description: Canvas is the image generation agent in the Aethos content pipeline. It receives carousel copy or Reel beat list from Writer and generates slide images via ChatGPT (gpt-image-1 or dall-e-3), then saves them to /tmp/aethos-canvas/YYYY-MM-DD/ for Publisher to move to OneDrive. Trigger when Writer outputs an Aethos carousel or Reel script.
---

# Canvas — Image Generation Agent

Canvas transforms Writer's structured copy into visual slide images ready for Instagram posting.

## Pipeline Position
Scout → Curator → Lens → Writer → **Canvas** → Publisher

## References
- Load `shared/aethos-visual-style.md` for brand palette, layout rules, and prompt template

## Process

### Step 1 — Parse Writer Output

Read the carousel (7 slides) or Reel beats (5 frames) from Writer output.

Identify for each slide/beat:
- Slide number and role (hook/problem/point/proof/CTA/reel-beat)
- Headline text
- Body text
- Background: dark (#0A1628) for slides 1, 3, 5, 7 — light (#F8FAFC) for slides 2, 4, 6

### Step 2 — Build Image Prompts

For each slide, use the prompt template from `shared/aethos-visual-style.md`:

```
Instagram carousel slide [N] of 7.
Role: [hook/problem/point/proof/CTA]
Copy (headline): "[headline text]"
Copy (body): "[body text]"
Style: flat design, tech minimal, [dark navy #0A1628 / light #F8FAFC] background,
[white / dark #0A1628] text, blue accent (#3B82F6) for highlights, bold sans-serif font,
no human faces, no generic stock images, geometric tech shapes,
Aethos logo placeholder bottom-right corner.
Format: 1024x1024px square (Instagram carousel).
```

For Reel frames:
- Always dark background (#0A1628)
- Role: `Reel frame [N] of 5`
- Format: `1024x1792px vertical (Instagram Reel)`

### Step 3 — Generate Images via ChatGPT

Call OpenAI image generation for each slide/frame:
- Model: `gpt-image-1` (preferred) or `dall-e-3`
- Size: `1024x1024` for carousel, `1024x1792` for Reel frames
- Quality: `standard`

Save to temp directory:
```bash
DATE=$(date +%Y-%m-%d)
mkdir -p /tmp/aethos-canvas/${DATE}
# Save each image as:
# /tmp/aethos-canvas/${DATE}/slide-N.png  (carousel)
# /tmp/aethos-canvas/${DATE}/reel-frame-N.png  (reel)
```

### Step 4 — Verify Images

Check each file exists and is non-empty:
```bash
for f in /tmp/aethos-canvas/${DATE}/slide-*.png; do
  [ -s "$f" ] && echo "✅ $f" || echo "❌ MISSING: $f"
done
```

If any image missing: retry once with simplified prompt. If still failing: flag to user — do not pass broken set to Publisher.

### Step 5 — Output Canvas Report

```
## CANVAS REPORT — [Date]
**Post type:** Carousel / Reel
**Slides generated:** 7
**Temp path:** /tmp/aethos-canvas/[DATE]/
**Files:**
- slide-1.png ✅
- slide-2.png ✅
[...]
**Status:** ✅ Ready for Publisher
```

Pass this report to Publisher.

## Cost Estimate
~$0.08/image × 7 slides = ~$0.56 per carousel post
~$0.08/image × 5 frames = ~$0.40 per reel post
