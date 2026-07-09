# Influence Campaign Skill — Design

**Date:** 2026-07-08
**Status:** Approved
**Authors:** Greg Weinger & Ryan Latta (joint)

## Overview

A guided, stateful workflow that helps an introverted technical leader plan and run an influence campaign for an initiative: mapping who matters, what each person responds to, sequencing outreach, and drafting the actual messages. Unlike most skills in this repo, this one maintains persistent state across sessions — a rapport map of people the leader works with, reused across every campaign they run.

This design supersedes the two competing drafts in `influence-campaign/notes.md` (Greg's linear single-workflow draft and Ryan's three-mode addendum) by adopting Ryan's three-mode framing as the full v1 scope.

## Trigger Criteria

Activates when the user needs something from someone who doesn't report to them. Test: "do you need permission or buy-in to do this?" Explicit trigger phrases: "get people on board with X," "how do I get buy-in," "I want to pitch this to leadership," "nobody's paying attention to this proposal."

## Package Structure

```
influence-campaign/
├── SKILL.md                     # router: trigger criteria, mode dispatch, points into references/
├── AUTHORS                       # Greg Weinger, Ryan Latta
├── references/
│   ├── leader-priming.md         # Mode 0: one-time interview of the user
│   ├── rapport-mapping.md        # Mode 1: build/update per-person profiles
│   ├── influence-building.md     # Mode 2: campaign creation, resumption, recommendations
│   ├── influence-models.md       # Cohen & Bradford (default), Cialdini, power/interest grid, RACI
│   └── file-formats.md           # markdown templates: person file, campaign file, leader profile, pointer file
```

`SKILL.md` stays a thin router per this repo's convention of keeping `SKILL.md` focused and pushing long material into `references/`. It identifies which mode applies and dispatches, rather than holding all interview scripts inline.

## Storage Architecture

**People are global; campaigns are separate.** A person's rapport-map file is shared across every campaign the leader runs — their working style, relationships, and currencies don't change per-initiative. A campaign file holds what's specific to that push: the goal, the relevant stakeholder subset, the sequencing plan, and that campaign's interaction log.

```
<notes-root>/
├── leader-profile.md             # Mode 0 output, written once
├── people/
│   ├── jane-vp-product.md
│   └── mark-staff-eng.md
├── campaigns/
│   ├── platform-migration.md
│   └── hiring-plan-pitch.md
└── .influence-campaign-config     # pointer file recording notes-root path
```

**Locating notes-root:** on first-ever run (no config file found in the expected location), the skill asks the user where to keep notes — an existing Obsidian-style vault, a dedicated folder, or a repo subfolder — and writes a pointer file so subsequent runs reuse that location automatically. This avoids fragmenting notes per-project-directory and lets a person who already keeps notes elsewhere point the skill at that existing material.

**Why the split:** a person (e.g. Jane, VP of Product) can be a stakeholder in multiple concurrent campaigns. Her profile must not fork into per-campaign copies, but the outreach plan and conversation history for each campaign must stay separate so a nudge about one initiative doesn't get confused with another.

**Dual-write on interaction logging:** when an interaction is logged, full detail (what was said, outcome, next step) goes into that campaign's file; the person's file receives one rolling summary line (e.g. `2026-07-01 — outreach re: platform-migration, positive`) so her overall relationship read stays current regardless of which campaign context she's viewed from later.

**Disambiguating resumption:** if the user's message names the initiative, the skill dispatches directly to that campaign file. If ambiguous and more than one campaign file exists, the skill lists open campaigns and asks which one applies before recommending a next move.

## Modes

### Mode 0 — Leader Priming (one-time, ever)

Runs once, before any campaign or rapport-map work, when `leader-profile.md` doesn't yet exist. Light-touch interview (from Ryan's notes, used as-is):

- Preferred way to interact with peers/superiors
- When face-to-face beats virtual communication, in their experience
- How they've successfully built rapport in the past
- What feels awkward, clumsy, or unnatural when building rapport
- Whether developing this skill is something they want, given it'll push them outside their comfort zone
- Influence-building material they're already familiar with
- Sources of influence-building the skill should consider when recommending
- What methods or techniques are explicitly out of bounds

Written to `leader-profile.md`. Read (never re-asked) by Modes 1 and 2 to calibrate tone, stretch, and off-limits tactics.

### Mode 1 — Rapport Mapping (per person, checked at campaign start)

At the start or resumption of any campaign, the skill runs a checklist pass over **every** stakeholder in scope — not just newly-discovered ones:

- **No file exists for this person:** run the full interview — name/title/area of responsibility, what they respond to/working style, who they have a positive relationship with, who they have a negative relationship with, and the leader's own relationship with them (valence, shared history, key moments). Written to `people/<name>.md`.
- **File already exists:** ask only "anything changed with [name] since we last touched base?" rather than re-running the full interview. Update the file if the answer surfaces anything new.

This runs as an explicit up-front pass over the whole stakeholder list before the campaign proceeds, not something discovered incidentally person-by-person mid-campaign.

### Mode 2 — Influence Building (the campaign engine)

**Starting a new campaign:** create `campaigns/<slug>.md`; push back if the goal is vague (e.g. "get people on board with X" with no concrete definition of "adopted") until there's a real win condition and forcing function/deadline, per Greg's original step 1. Identify the stakeholder subset using the power/interest grid. Run the Mode 1 checklist pass over that subset.

**Resuming a campaign:** read the campaign file plus the relevant people files; ask "anything new happened — email, meeting, conversation — since last time?" and treat the answer as a pivot point to the plan.

**Recommending a move:** each turn, recommend 2–3 sized options for the single next-best person to move on — e.g. "quick Slack DM," "coffee invite," "wait for a natural opening" — calibrated against the leader's comfort/stretch preference from Mode 0. This is an options menu, not a single prescriptive recommendation.

**Message drafting** is folded into Mode 2 rather than a separate mode: once a specific move is chosen, draft the actual first-pass message using the person's file (currency, working style) and the campaign's narrative.

**Logging:** after the leader acts, log the outcome per the dual-write rule in Storage Architecture.

## Influence Model

**Default: Cohen & Bradford currencies of influence** (inspiration, task-related, position, relationship, personal). Used specifically in Mode 1's "what do they respond to" question — the skill prompts with currency categories if the leader's initial answer is vague.

**Power/interest grid** frames Mode 2's stakeholder mapping (who decides, who blocks, who's a swing vote, who's an ally).

**RACI** is an optional clarifying question only, used when decision rights are genuinely unclear ("who actually signs off on this?") — not run by default.

**Cialdini's principles** live in `references/influence-models.md` as a silent checklist the message-drafting step checks against (reciprocity, social proof, etc.), not surfaced to the user as a named framework.

## Inputs and Outputs

**Inputs:** the initiative/goal, the stakeholder list (or the skill helps generate it via the power/interest grid), free-form leader notes on each person, and the one-time leader profile.

**Outputs:** a stakeholder map, a campaign file with sequenced next-move recommendations, drafted first-pass messages for the highest-priority people, and the persistent people/campaign files as a standing artifact — not just a one-off document.

## Demo / Test Scenario

An EM pushing a platform-migration proposal that needs sign-off from a VP of Product who "loves to talk about product" (drawn from Ryan's real material), a skeptical staff engineer who's a swing vote, and a peer EM who's a quiet existing ally. Exercises: new-person rapport mapping (VP + staff eng), an existing ally requiring only the lightweight update check, power/interest placement, a currency-based message draft to the VP, and a resume-after-a-week test with a new "an email happened" pivot.

## Error Handling / Edge Cases

- No `notes-root` configured yet → run the one-time path prompt before anything else.
- Person exists in `people/` but not yet in this campaign's scope → run the "anything changed" check, not a fresh interview.
- Campaign goal is vague → push back and require a concrete win condition before mapping anyone.
- Ambiguous resume target with multiple open campaigns → list them and ask which one, rather than guessing.

## Open Items Outside This Spec

- Ryan should sign off on Cohen & Bradford as the default influence model before this ships, given the notes originally deferred that call to his consulting experience.
- The exact markdown templates for each file type (`file-formats.md`) are implementation detail for the plan, not this design.
