# Aethos Visual Style — Canvas Agent Reference

## Brand Palette
- **Primary:** #0A1628 (dark navy)
- **Secondary:** #FFFFFF (white)
- **Accent:** #3B82F6 (blue-500)
- **Text on dark:** #F8FAFC
- **Text on light:** #0A1628
- **Dividers:** #1E3A5F

## Typography
- **Headline:** Bold, sans-serif (Inter/DM Sans)
- **Body:** Regular 16–18px, max 20 words per slide
- **Max chars per slide:** 120 (headline + body combined)

## Layout Rules
- Dark background (#0A1628) with white text — default for slides 1, 3, 5, 7
- Light background (#F8FAFC) with dark text — slides 2, 4, 6 (alternating)
- Aethos logo bottom-right on every slide (small, unobtrusive)
- No stock photos of generic people. Use: abstract tech patterns, code snippets, geometric shapes, real product screenshots if available.

## Slide Structure (Carousel — 7 slides)
| Slide | Role | Style |
|-------|------|-------|
| 1 | Hook — bold claim or question | Dark bg, large headline, minimal |
| 2 | Problem — audience pain | Light bg, icon + text |
| 3 | Point 1 | Dark bg, numbered, concise |
| 4 | Point 2 | Light bg, numbered, concise |
| 5 | Point 3 | Dark bg, numbered, concise |
| 6 | Proof / Example | Light bg, stat or mini-case |
| 7 | CTA | Dark bg, strong verb, link na bio |

## Prompt Template (for ChatGPT image gen)

Use this exact structure for each slide prompt sent to ChatGPT:

```
Instagram carousel slide [N] of 7.
Role: [hook/problem/point/proof/CTA]
Copy (headline): "[headline text]"
Copy (body): "[body text]"
Style: flat design, tech minimal, [dark navy #0A1628 / light #F8FAFC per slide rule] background,
[white / dark #0A1628] text, blue accent (#3B82F6) for highlights, bold sans-serif font,
no human faces, no generic stock images, geometric tech shapes,
Aethos logo placeholder bottom-right corner.
Format: 1024x1024px square (Instagram carousel).
```

## Reel Frame Style
- Same palette, dark background default
- Text overlay centered, large bold white
- Bottom bar: thin blue accent line with Aethos handle (@aethos.tech)
- 5–6 frames total, each 5 seconds
- No talking head — text + geometric visual only
