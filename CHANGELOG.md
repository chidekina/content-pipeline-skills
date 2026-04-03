# Changelog

## v1.1.0 — 2026-04-03
### Added
- `update-profile` skill — edit specific sections of `brand_voice.md` without repeating the full onboarding
- Option C (native Windows PowerShell) installation instructions in both READMEs
- "How to update" section in both READMEs

### Fixed
- README.md (EN): translated remaining Portuguese sections, added `update-profile` to install commands and agents table
- README.md (EN): "Option A" now copies 7 skills (was missing `update-profile`)

### Internal
- Added `.gitignore`
- Onboarding flow in Scout is now language-aware (detects user language before asking questions)
- `pipeline.md` consolidation: source of truth moved to `shared/pipeline.md`; `sync-pipeline.sh` keeps all skill copies in sync

## v1.0.0 — 2026-03-01
### Added
- Initial release: Scout, Curator, Lens, Writer, Brief, Pulse
- Full onboarding flow on first `/scout` run
- Pulse → Scout feedback loop via `last_feedback.md`
