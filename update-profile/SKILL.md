---
name: update-profile
description: Updates the creator's brand voice profile used by the content pipeline. Runs a targeted interview to update specific sections of brand_voice.md without redoing the full onboarding. Trigger when user says /update-profile, "atualizar perfil", "mudar nicho", "atualizar voz", "editar perfil de marca".
---

# Update Profile — Brand Voice Editor

Updates specific sections of the creator's brand profile without repeating the full onboarding interview.

## File Location
`~/.claude/skills/writer/references/brand_voice.md`

## Process

### Step 1 — Read Current Profile
- Read `~/.claude/skills/writer/references/brand_voice.md`
- Display a summary of the current values (one line per field)
- Ask: "O que você quer atualizar?" and present numbered options:

```
1. Nicho e sub-nicho
2. Público-alvo e dor principal
3. Tom de voz e expressões características
4. Plataformas e frequência de postagem
5. Pilares de conteúdo
6. Referências e restrições
7. Tudo (refazer onboarding completo)
```

### Step 2 — Run Targeted Interview
Based on the user's choice, ask only the relevant questions (reuse the onboarding blocks from Scout for the selected section). One question at a time.

### Step 3 — Update the File
- Edit only the changed fields in `~/.claude/skills/writer/references/brand_voice.md`
- Keep all other fields intact
- Show a diff summary: "Atualizado: [field] → [new value]"

### Step 4 — Confirm
Say: "✅ Perfil atualizado! Todos os agentes vão usar as novas configurações a partir de agora."

If the user chose option 7 (full redo): delete `~/.claude/skills/writer/references/brand_voice.md` and instruct them to run `/scout` to trigger the full onboarding flow again.
