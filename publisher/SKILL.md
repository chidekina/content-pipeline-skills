---
name: publisher
description: Publisher is the final publishing agent in the Aethos content pipeline. It receives the Canvas Report (public image URLs + caption) and posts to @aethos.tech Instagram via Graph API. For Reels (Fridays), it first assembles the slideshow video with ffmpeg. Trigger after Canvas outputs a ready report.
---

# Publisher — Instagram Publishing Agent

Publisher takes Canvas-verified image URLs and publishes to @aethos.tech via Instagram Graph API.

## Pipeline Position
Scout → Curator → Lens → Writer → Canvas → **Publisher** → Pulse

## References
- See `references/instagram-api.md` for API commands and token management

## Environment (VPS: 148.230.73.61)
- `INSTAGRAM_ACCESS_TOKEN` — long-lived token (60 days, auto-renewed)
- `INSTAGRAM_ACCOUNT_ID` — Business Account ID for @aethos.tech
- Images: `/data/aethos-content/YYYY-MM-DD/`
- Public base: `https://assets.aethostech.com.br/content/`
- Music: `/data/aethos-music/*.mp3`

## Process

### Step 1 — Validate Canvas Report

Before posting, confirm:
- All image URLs return HTTP 200
- Caption is present and ≤ 2200 chars
- Correct post type (carousel vs reel) matches day of week
  - Monday / Wednesday → carousel
  - Friday → reel

If validation fails: halt, log to `/data/aethos-content/errors.log`, create ARIA task.

### Step 2a — Carousel Publishing (Mon/Wed)

Follow carousel flow from `references/instagram-api.md`:
1. Create media container for each of the 7 slides
2. Create carousel container with all 7 container IDs
3. Publish carousel
4. Capture returned `IG_POST_ID`

### Step 2b — Reel Assembly + Publishing (Fri)

**Assemble video with ffmpeg:**

```bash
DATE=$(date +%Y-%m-%d)
CONTENT_DIR="/data/aethos-content/${DATE}"

# Build input list (5 frames, 5 seconds each)
rm -f /tmp/reel-input.txt
for i in 1 2 3 4 5; do
  echo "file '${CONTENT_DIR}/reel-frame-${i}.png'" >> /tmp/reel-input.txt
  echo "duration 5" >> /tmp/reel-input.txt
done

# Pick random royalty-free track
TRACK=$(ls /data/aethos-music/*.mp3 | shuf -n1)

# Assemble: scale to 1080x1920, add audio fade out, limit to 30s
ffmpeg -f concat -safe 0 -i /tmp/reel-input.txt \
  -i "$TRACK" \
  -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,fps=30" \
  -af "afade=t=out:st=25:d=5" \
  -t 30 \
  -c:v libx264 -c:a aac \
  "${CONTENT_DIR}/reel.mp4"
```

Then follow Reel publishing flow from `references/instagram-api.md`.

### Step 3 — Log Publish

Append to `/data/aethos-content/publish-log.jsonl`:
```json
{"date":"YYYY-MM-DD","type":"carousel","post_id":"IG_POST_ID","status":"published","caption_preview":"first 60 chars of caption..."}
```

### Step 4 — Output Publisher Report

```
## PUBLISHER REPORT — [Date]
**Type:** Carousel / Reel
**Post ID:** [IG_POST_ID]
**Published at:** HH:MM
**Status:** ✅ Published
```

Pass this to Pulse for analytics tracking.

## Error Handling

| Error | Action |
|-------|--------|
| API auth error (401) | Token expired — run renewal script, retry once |
| API rate limit (429) | Wait 60s, retry |
| Video processing timeout >10 min | Log error, create ARIA task, skip this run |
| ffmpeg fail | Log stderr to errors.log, create ARIA task |
| Any unrecovered error | Log to errors.log, do NOT attempt to publish partial content |
