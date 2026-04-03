---
name: update-profile
description: Updates the creator's brand voice profile used by the content pipeline. Runs a targeted interview to update specific sections of brand_voice.md without redoing the full onboarding. Trigger when user says /update-profile, "atualizar perfil", "mudar nicho", "atualizar voz", "editar perfil de marca".
---

# Update Profile — Brand Voice Editor

Updates specific sections of the creator's brand profile without repeating the full onboarding interview.

## File Location
`~/.claude/skills/writer/references/brand_voice.md`

## Process

**Detect language first:** Conduct the entire interaction in the same language the user wrote in. Default to English if unclear.

### Step 1 — Read Current Profile
- Read `~/.claude/skills/writer/references/brand_voice.md`
- Display a summary of the current values (one line per field)
- Ask what they want to update and present numbered options:

```
1. Niche & sub-niche
2. Target audience & main pain point
3. Voice, tone & signature phrases
4. Platforms & posting frequency
5. Content pillars
6. References & constraints
7. Everything (redo full onboarding)
```

### Step 2 — Run Targeted Interview
Based on the user's choice, ask only the relevant questions (reuse the onboarding blocks from Scout for the selected section). One question at a time.

### Step 3 — Update the File
- Edit only the changed fields in `~/.claude/skills/writer/references/brand_voice.md`
- Keep all other fields intact
- Show a diff summary: "Updated: [field] → [new value]"

### Step 4 — Confirm
Say: "✅ Profile updated! All agents will use the new settings from now on."

If the user chose option 7 (full redo): delete `~/.claude/skills/writer/references/brand_voice.md` and instruct them to run `/scout` to trigger the full onboarding flow again.
