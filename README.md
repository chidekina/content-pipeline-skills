# Content Pipeline Skills — Claude Code

A complete content marketing pipeline built as Claude Code skills. Six agents that work together to discover trends, curate, ideate, write scripts, plan the week, and continuously improve through data.

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
- [Claude Code](https://claude.ai/code) installed (`npm install -g @anthropic-ai/claude-code`)
- Anthropic account with API access

### Install skills

```bash
# Clone this repo
git clone <repo-url>
cd content-pipeline-skills

# Install each skill
claude skills install scout
claude skills install curator
claude skills install lens
claude skills install writer
claude skills install brief
claude skills install pulse
```

Or install from zip files (if provided):
```bash
claude skills install scout.zip
# repeat for each skill
```

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
