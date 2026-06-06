# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A collection of Claude Skills for introverted technology leaders (EMs, PMs, ICs). Each skill lowers the activation energy on a high-leverage move — producing a concrete artifact like a message, agenda, or plan — without pushing the user to act like an extrovert.

Skills are released under Apache 2.0 and come out of the [The Introverted Leader](https://gweinger.com) podcast.

## Skill Format

A skill is a folder. The canonical structure:

```
skill-name/
├── SKILL.md        # required — YAML frontmatter + instructions Claude reads
├── AUTHORS         # required — one author per line: Name <email>
├── references/     # optional — long reference material linked from SKILL.md
├── scripts/        # optional
└── assets/         # optional
```

`SKILL.md` must have YAML frontmatter with at minimum `name` and `description`. Keep the body focused; offload long reference material to `references/` and link to it.

## Authorship Model

Authorship is tracked **per skill**, not per repo.

- `AUTHORS` inside each skill folder is the authoritative record — it travels with the folder if redistributed.
- The summary table in `README.md` must stay in sync.
- Solo skills credit one author; co-authored skills list everyone.

## Build

```bash
make validate   # check all skills for correct structure
make dist       # package each skill as dist/<name>.skill (runs validate first)
make test       # run the test suite
make clean      # remove dist/
```

Validate checks: `SKILL.md` and `AUTHORS` present; `SKILL.md` frontmatter has `name:` and `description:`; slug appears in README.md skills table.

`dist/` is gitignored. Scripts accept an optional repo-root argument — `bash scripts/validate.sh /some/path` — which is how the test suite runs them against fixture directories.

When adding a new skill:
1. Create the skill folder with `SKILL.md` and `AUTHORS`.
2. Update the skills table in `README.md`.
3. Run `make validate` to confirm the skill passes all checks.

## Skills Planned / In Progress

From `README.md` (not all folders exist yet):

| Slug | Purpose |
|---|---|
| `influence-campaign` | Stakeholder map, outreach sequencing, message drafts |
| `meeting-analysis` | Post-meeting feedback from transcript |
| `difficult-conversations` | Prep for confrontation, hard feedback, pushback |
| `meeting-prep` | Pre-game: goals, objections, who's in the room |
| `big-room-survival` | Surviving multi-day high-stimulation events |

## Style Guidance (from CONTRIBUTING.md)

Plain, direct, first-person where it fits. Audience is busy, competent people. Reduce activation energy; produce a concrete artifact; don't lecture.
