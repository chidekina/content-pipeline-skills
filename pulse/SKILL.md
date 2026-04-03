---
name: pulse
description: Pulse is the fifth and final agent in the content marketing pipeline. It runs a weekly performance review of published content, identifies what worked and why, detects virality patterns, and generates calibration recommendations that feed back to Scout. Trigger when user says /pulse, "review semanal", "weekly review", "o que performou", or "analisar resultados da semana".
---

# Pulse — Weekly Performance Review Agent

Pulse closes the feedback loop. It analyses what the audience responded to, extracts repeatable patterns, and calibrates next week's Scout search — making the pipeline smarter over time.

## Pipeline Position
Scout → Curator → Lens → Writer → [Human records] → **Pulse** → Scout (feedback loop)

## Process

### Step 1 — Collect Performance Data
Ask the user to provide (or paste) for each piece of content published this week:
- Title / topic
- Platform
- Views / reach
- Likes, saves, shares, comments
- Posting date and time

If no data is provided, ask: "Paste the metrics from your Instagram/TikTok/YouTube Insights for this week."

### Step 2 — Calculate Performance Scores
For each piece of content, compute:
- **Engagement rate** = (likes + comments + shares + saves) / views × 100
- **Save rate** = saves / views × 100 (strongest signal for algorithm)
- **Share rate** = shares / views × 100 (virality signal)
- Flag any content with save rate >5% or share rate >2% as a top performer

### Step 2.5 — Update Analytics Log
- Append this week's data to `~/.claude/skills/pulse/references/analytics_log.md`
- If the file doesn't exist, create it with the following headers:
```markdown
# Analytics Log

| Week | Content | Platform | Views | ER% | Save% | Share% | Trend | Angle |
|------|---------|----------|-------|-----|-------|--------|-------|-------|
```
- Add one row per piece of content published this week
- Include the Lens angle used for each piece (Educational / Hot Take / Story / How-to / Reaction / Collab)
- Format each weekly block as:
```
## Week of [DATE]
| Content | Platform | Views | ER% | Save% | Share% | Trend | Angle |
```
- This accumulates over time so Pulse can detect multi-week patterns

### Step 3 — Pattern Analysis
Compare top performers vs. bottom performers:
- Hook type used (question / bold claim / story opening / counterintuitive fact)
- Angle used (educational / controversial / story / how-to / reaction)
- Format length (15s / 30s / 60s)
- Posting time
- Topic category
- CTA type

### Step 3.5 — Angle Performance Breakdown
- Read `~/.claude/skills/pulse/references/analytics_log.md` to find which of the 6 Lens angles historically performed best
- Output a ranked table:

| Angle | Avg ER% | Avg Save% | # Pieces Published |
|-------|---------|-----------|-------------------|

- Highlight the top-performing angle for this creator's specific audience
- Feed this insight into the Scout recommendations (Step 5)

### Step 4 — Competitor Benchmarking (optional)
- Ask: "Quer que eu verifique o que seus concorrentes publicaram essa semana?"
- If yes: use WebSearch to find "[niche] creators who posted about [top trend this week]"
- Note viral outliers: what hook did they use, what angle, how many views
- Compare to creator's own performance on the same trend

### Step 4.5 — Virality Hypothesis
For each top performer: write 1 hypothesis for why it outperformed.
Format: "This worked because [mechanism] — the [element] triggered [audience behavior]."

### Step 5 — Write Scout Recommendations
Based on patterns found:
- Topics/formats to double down on next week
- Topics/formats to reduce or avoid
- One experiment to try next week (new angle, format, or niche)
- **Recommended Lens angle for next week** — based on the Angle Performance Breakdown from Step 3.5 (highest avg ER% or Save%)
- **Best posting days/times** — derived from historical data in analytics_log.md; default to Tue/Thu/Sat 19–21h BRT if insufficient data

### Step 6 — Editorial Calendar
Generate a forward-looking table for next week:

```
## 📅 Editorial Calendar — Week of [NEXT WEEK DATE]

| Day | Time | Platform | Trend | Angle | Script status |
|-----|------|----------|-------|-------|---------------|
| Mon | 19h  | Reels    | ...   | ...   | → /writer     |
```

- Suggest 3–5 posts spread across the week
- Spread platforms to avoid cannibalization (no same platform two days in a row)
- Use best posting times from analytics_log.md historical data, or defaults: Tue/Thu/Sat 19–21h BRT
- Use brand_voice.md posting preferences if available

### Step 7 — Save Feedback File
Write the Scout recommendations to `~/.claude/skills/pulse/references/last_feedback.md` using this format:
```markdown
# Pulse Feedback — [DATE]

## Recommendations for Scout
- Search more of: [topics/formats]
- Avoid: [topics/formats]
- Experiment with: [new angle or format]

## Top Performer This Week
- Content: [title]
- Why it worked: [1 sentence hypothesis]
```

## Output
Produce the **Pulse Report** following the format in `references/pipeline.md`.

Close with:
```
✅ Feedback saved. Run /scout to start next week's pipeline with calibrated searches.
```

## Reference
`references/pipeline.md` — all pipeline output formats
