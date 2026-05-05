# Instagram Graph API — Quick Reference

## Requirements
- Instagram Business or Creator account (@aethos.tech)
- Facebook App with permissions:
  - `instagram_basic`
  - `instagram_content_publish`
  - `pages_read_engagement`
  - `instagram_manage_insights`
- Long-lived User Access Token (valid 60 days)
- Instagram Business Account ID

## Environment Variables (VPS /etc/environment)
```
INSTAGRAM_ACCESS_TOKEN=...
INSTAGRAM_ACCOUNT_ID=...
```

## Carousel Publishing Flow

```bash
# 1. Create media container for each image (repeat for all 7 slides)
curl -X POST "https://graph.facebook.com/v19.0/${INSTAGRAM_ACCOUNT_ID}/media" \
  -F "image_url=https://assets.aethostech.com.br/content/DATE/slide-1.png" \
  -F "is_carousel_item=true" \
  -F "access_token=${INSTAGRAM_ACCESS_TOKEN}"
# Returns: { "id": "CONTAINER_ID_1" }

# 2. Create carousel container with all slide IDs
curl -X POST "https://graph.facebook.com/v19.0/${INSTAGRAM_ACCOUNT_ID}/media" \
  -F "media_type=CAROUSEL" \
  -F "children=CONTAINER_ID_1,CONTAINER_ID_2,CONTAINER_ID_3,CONTAINER_ID_4,CONTAINER_ID_5,CONTAINER_ID_6,CONTAINER_ID_7" \
  -F "caption=CAPTION_TEXT" \
  -F "access_token=${INSTAGRAM_ACCESS_TOKEN}"
# Returns: { "id": "CAROUSEL_CONTAINER_ID" }

# 3. Publish carousel
curl -X POST "https://graph.facebook.com/v19.0/${INSTAGRAM_ACCOUNT_ID}/media_publish" \
  -F "creation_id=CAROUSEL_CONTAINER_ID" \
  -F "access_token=${INSTAGRAM_ACCESS_TOKEN}"
# Returns: { "id": "IG_POST_ID" }
```

## Reel Publishing Flow

```bash
# 1. Assemble video with ffmpeg (run before upload)
# See Publisher SKILL.md for ffmpeg command

# 2. Upload Reel video
curl -X POST "https://graph.facebook.com/v19.0/${INSTAGRAM_ACCOUNT_ID}/media" \
  -F "media_type=REELS" \
  -F "video_url=https://assets.aethostech.com.br/content/DATE/reel.mp4" \
  -F "caption=CAPTION_TEXT" \
  -F "access_token=${INSTAGRAM_ACCESS_TOKEN}"
# Returns: { "id": "REEL_CONTAINER_ID" }

# 3. Poll for processing completion (retry every 30s, max 10 min)
curl "https://graph.facebook.com/v19.0/REEL_CONTAINER_ID?fields=status_code&access_token=${INSTAGRAM_ACCESS_TOKEN}"
# Wait until status_code = "FINISHED"

# 4. Publish Reel
curl -X POST "https://graph.facebook.com/v19.0/${INSTAGRAM_ACCOUNT_ID}/media_publish" \
  -F "creation_id=REEL_CONTAINER_ID" \
  -F "access_token=${INSTAGRAM_ACCESS_TOKEN}"
```

## Token Renewal (every 45 days via cron)

```bash
curl "https://graph.facebook.com/v19.0/oauth/access_token?\
grant_type=fb_exchange_token\
&client_id=${FB_APP_ID}\
&client_secret=${FB_APP_SECRET}\
&fb_exchange_token=${INSTAGRAM_ACCESS_TOKEN}"
```

Add to crontab on VPS:
```
0 9 1 */1 * /home/user/scripts/renew-instagram-token.sh
```

## Rate Limits
- 25 API calls per hour per token
- Max 50 posts per 24h per account
- Images: JPEG/PNG, max 8MB, min 320px square, max 1440px
- Carousel: 2–10 images per post
- Reel video: MP4/MOV, H.264, max 15 min, min 3s, 9:16 aspect ratio recommended

## Instagram Insights API (for Pulse)

```bash
curl "https://graph.facebook.com/v19.0/${POST_ID}/insights?\
metric=reach,impressions,saved,shares,comments_count,likes\
&access_token=${INSTAGRAM_ACCESS_TOKEN}"
```
