# Content Pipeline Skills — Claude Code

A complete content marketing pipeline built as Claude Code skills. Seven agents that work together to discover trends, curate, ideate, write scripts, plan the week, continuously improve through data, and keep your brand voice up to date.

## Pipeline Flow

```
/scout → /curator → /lens → /writer → /brief → [Human records & publishes] → /pulse → /scout
```

## Agents

| Agent | Role | Command |
|-------|------|---------|
| **Scout** | Discovers trends across YouTube Shorts, TikTok, Instagram, Twitter/X, Google Trends, and Reddit. Tags production complexity and competitor saturation. | `/scout` |
| **Curator** | Scores each trend on 6 criteria (engagement, audience fit, shelf life, originality, production complexity, opportunity window). Selects top 5. | `/curator` |
| **Lens** | Refracts each trend into 6 creative angles: Educational, Hot Take, Personal Story, How-to, Trend Reaction, and Collab/Duet. Ranks by execution risk. | `/lens` |
| **Writer** | Writes a complete, production-ready script: hook, development, CTA, thumbnail copy, B-roll shot list, SEO caption, and pinned comment. | `/writer` |
| **Brief** | Consolidates all scripts into a prioritized weekly editorial calendar with effort estimates and a pre-recording checklist. | `/brief` |
| **Pulse** | Weekly performance review: engagement analysis, angle breakdown, competitor benchmarking, historical analytics log, and editorial calendar for next week. Feeds recommendations back to Scout. | `/pulse` |
| **Update Profile** | Edits specific sections of your brand voice profile (`brand_voice.md`) without repeating the full onboarding — useful when your niche, tone, or platforms change. | `/update-profile` |

## First Use — Onboarding

Run `/scout` for the first time. It will detect that no brand profile exists and conduct a short onboarding interview (5 blocks, one at a time) to capture:

- Creator identity & niche
- Target audience & pain points
- Voice, tone & signature phrases
- Platforms, posting frequency & content pillars
- References & content constraints

The profile is saved to `~/.claude/skills/writer/references/brand_voice.md` and used automatically by all agents from that point on.

## Installation

### Prerequisites

1. **Node.js 18+** — [nodejs.org/en/download](https://nodejs.org/en/download)
2. **Claude Code** — install via terminal:
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```
3. **Anthropic account** with API access — [console.anthropic.com](https://console.anthropic.com)

### Install the skills

**Option A — via Git (recommended)**
```bash
# Clone the repository
git clone https://github.com/chidekina/content-pipeline-skills.git

# Copy the 7 skills to Claude Code's skills folder
cp -r content-pipeline-skills/scout          ~/.claude/skills/
cp -r content-pipeline-skills/curator        ~/.claude/skills/
cp -r content-pipeline-skills/lens           ~/.claude/skills/
cp -r content-pipeline-skills/writer         ~/.claude/skills/
cp -r content-pipeline-skills/brief          ~/.claude/skills/
cp -r content-pipeline-skills/pulse          ~/.claude/skills/
cp -r content-pipeline-skills/update-profile ~/.claude/skills/
```

**Option B — single command (macOS / Linux / WSL)**
```bash
git clone https://github.com/chidekina/content-pipeline-skills.git && \
  for skill in scout curator lens writer brief pulse update-profile; do
    cp -r content-pipeline-skills/$skill ~/.claude/skills/
  done
```

**Option C — Windows (native PowerShell)**
```powershell
git clone https://github.com/chidekina/content-pipeline-skills.git
cd content-pipeline-skills
foreach ($skill in @("scout","curator","lens","writer","brief","pulse","update-profile")) {
    Copy-Item -Recurse $skill "$env:USERPROFILE\.claude\skills\"
}
```

> **macOS / Linux:** use Option A or B directly in the terminal.
> **Windows CMD/PowerShell:** use Option C above.
> **Windows with WSL or Git Bash:** use Option B.

### Verify installation

Open Claude Code and run:
```
/skills
```
You should see `scout`, `curator`, `lens`, `writer`, `brief`, `pulse`, and `update-profile` in the list.

## Weekly Workflow

```
Monday morning:
  /scout          → Discover this week's trends

Monday afternoon:
  /curator        → Select top 5 trends

Monday evening:
  /lens           → Generate 6 angles per trend

Tuesday:
  /writer         → Write scripts for selected trend + angle combos
  /brief          → Build the week's editorial plan

Tue–Sat:
  [Record & publish following Brief's calendar]

Friday:
  /pulse          → Review performance, update analytics log, calibrate next Scout
```

## Feedback Loop

Pulse saves recommendations to `~/.claude/skills/pulse/references/last_feedback.md`. Scout reads this file on every run to calibrate searches — meaning the pipeline gets smarter every week based on what actually performed.

## Example Output

**Scout** produces a raw trends table like this:

```
| # | Trend                        | Platform(s)           | Signal | Complexity | Competitor Status |
|---|------------------------------|-----------------------|--------|------------|------------------|
| 1 | "AI tools for small business"| YT Shorts, Google     | High   | 🟢 Easy    | ⚠️ Covered       |
| 2 | "$5 meal prep challenge"      | TikTok, Reels         | High   | 🟢 Easy    | ✅ Gap           |
| 3 | "Morning routine productivity"| YT Shorts, Instagram  | Medium | 🟡 Medium  | 🔴 Saturated     |
```

**Writer** produces a full script like this:

```
## Script — "$5 meal prep challenge" | How-to | Format: Reels/TikTok

### HOOK (0–3s)
"I fed myself for an entire week on $5. Here's exactly how."

### DEVELOPMENT (4–45s)
- Beat 1: Show the $5 bill. "This is my budget."
- Beat 2: Walk through the grocery list [B-roll: store aisle]
- Beat 3: Prep montage — 3 meals in 60 seconds [B-roll: cutting board, pots]
- Beat 4: Final reveal — 7 containers lined up

### CTA (last 3–5s)
"Save this for your next grocery run. Follow for weekly budget hacks."

### CAPTION
I fed myself for a week on $5 — and it actually tasted good.

Here's the full grocery list + 3 meals you can prep in under an hour.

#mealprep #budgetmeals #cheaprecipes #moneysaving #healthyonabudget
```

## How to Update

When a new version is released, pull and re-copy:

```bash
cd content-pipeline-skills
git pull
for skill in scout curator lens writer brief pulse update-profile; do
  cp -r $skill ~/.claude/skills/
done
```

Your runtime files (`brand_voice.md`, `last_feedback.md`, `analytics_log.md`) live in `~/.claude/skills/` and are never overwritten by this process.

## File Structure

```
skill-name/
├── SKILL.md              — Agent instructions
└── references/
    └── pipeline.md       — Shared output format specs
```

Key runtime files (created automatically):
```
~/.claude/skills/writer/references/brand_voice.md     — Creator profile (onboarding)
~/.claude/skills/pulse/references/last_feedback.md    — Weekly Scout calibration
~/.claude/skills/pulse/references/analytics_log.md    — Cumulative performance data
```
