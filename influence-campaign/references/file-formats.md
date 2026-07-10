# File Formats

All files below live under `<notes-root>`, the folder recorded in `.influence-campaign-config` (see `SKILL.md` for how that's located/created).

## `.influence-campaign-config`

Plain text, one line, absolute path to the notes root:

```
notes_root: /Users/example/notes/influence-campaign
```

## `leader-profile.md`

Written once by Mode 0 (`leader-priming.md`). Never regenerated — only read by later modes.

```markdown
# Leader Profile

- **Preferred interaction style:** [e.g. async written > live conversation]
- **Face-to-face vs. virtual:** [when the leader says face-to-face works better, and why]
- **Past rapport-building wins:** [what's worked before]
- **What feels awkward/unnatural:** [specific discomforts to route around, not push through]
- **Wants to stretch this skill?** [yes/no — whether to nudge outside comfort zone or stay safe]
- **Familiar influence material:** [named framework(s) the leader already thinks in, if any — takes priority over the Cohen & Bradford fallback, see influence-models.md]
- **Sources to consider when recommending:** [any additional material the leader wants factored in]
- **Off-limits methods:** [tactics the skill must never suggest]
```

## `people/<slug>.md`

One file per stakeholder, shared across all campaigns. `<slug>` is the person's name, lowercased, spaces replaced with `-` (e.g. `jane-doe.md`).

```markdown
# Jane Doe — VP of Product

- **Title / area:** VP of Product
- **Responds to / working style:** [currency or working-style read — see influence-models.md]
- **Positive relationships:** [who they get along with]
- **Negative relationships:** [who they clash with]
- **My relationship with them:** [valence, shared history, key moments]
- **Last touched base:** 2026-07-01

## Interaction log (rolling summary)
- 2026-07-01 — outreach re: platform-migration, positive
```

The "Interaction log (rolling summary)" section is the person-file half of the dual-write rule: one line per interaction, written from every campaign that touches this person, regardless of which campaign's file holds the full detail.

## `campaigns/<slug>.md`

One file per initiative. `<slug>` is the initiative name, lowercased, spaces replaced with `-` (e.g. `platform-migration.md`).

```markdown
# Campaign: Platform Migration

- **Win condition:** [concrete definition of "adopted" — not vague]
- **Deadline / forcing function:** [date or event]
- **Stakeholders:** Jane Doe (VP Product) — decider; Mark Chen (Staff Eng) — swing vote; Priya Shah (EM) — ally
- **Power/interest placement:** [who decides, who blocks, who's a swing vote, who's an ally]
- **Narrative:** [the one concrete story/example carrying the pitch]

## Interaction log (full detail)
- 2026-07-01 — Jane Doe — Slack DM re: migration timeline — she asked about rollout risk — next: follow up with a written risk summary
```

The campaign file's "Interaction log (full detail)" section holds full context; the corresponding person file gets only the one-line rolling summary (see above).
