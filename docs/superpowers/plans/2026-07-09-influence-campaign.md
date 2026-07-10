# Influence Campaign Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the `influence-campaign` Claude Skill package — a `SKILL.md` router plus `AUTHORS` and five `references/*.md` files — implementing the approved three-mode design (Leader Priming, Rapport Mapping, Influence Building) with persistent markdown-based state, per `docs/superpowers/specs/2026-07-08-influence-campaign-design.md`.

**Architecture:** A thin `SKILL.md` router dispatches to `references/*.md` files based on a two-branch decision tree (Leader Priming once, then Influence Building, which itself invokes Rapport Mapping as its first step). All persistent leader/people/campaign state is markdown under a user-chosen `<notes-root>`, located via a `.influence-campaign-config` pointer file created on first use.

**Tech Stack:** Markdown only (Claude Skill format). No new scripts — verification uses this repo's existing `scripts/validate.sh` and `Makefile`.

## Global Constraints

- `SKILL.md` frontmatter must include `name:` and `description:` (checked by `scripts/validate.sh`).
- Skill folder must contain an `AUTHORS` file, one author per line as `Name <email>` (per `CONTRIBUTING.md`).
- AUTHORS content, exact: `Greg Weinger <gweinger@gmail.com>` and `Ryan Latta <ryan@ryanlatta.com>`.
- Skill slug `influence-campaign` must appear in `README.md`'s skills table — it already does; verify, don't duplicate.
- No placeholder content ("TBD", "TODO", "fill in") in any shipped file.
- Leader's own stated influence material (from `leader-profile.md`) always overrides the Cohen & Bradford fallback — this was the reconciliation agreed in the spec's Influence Model section.
- People are global (`people/<slug>.md`), campaigns are separate (`campaigns/<slug>.md`) — never fork a person's profile per-campaign.
- Recommendations in Mode 2 are always a 2–3 option menu, never a single prescriptive move.

---

### Task 1: Skill scaffold — SKILL.md router + AUTHORS

**Files:**
- Create: `influence-campaign/SKILL.md`
- Create: `influence-campaign/AUTHORS`
- Test: repo root `scripts/validate.sh` (existing script, run directly — no new test file)

**Interfaces:**
- Produces: `SKILL.md` referencing five paths by name — `references/leader-priming.md`, `references/rapport-mapping.md`, `references/influence-building.md`, `references/influence-models.md`, `references/file-formats.md` — consumed by Tasks 2–6, which create those files.
- Produces: the pointer-file name `.influence-campaign-config` and its one-line format (`notes_root: <path>`) — consumed by Task 2 (`file-formats.md` must document this exact format).

- [ ] **Step 1: Write `influence-campaign/SKILL.md`**

```markdown
---
name: influence-campaign
description: "Use when the user needs buy-in, adoption, or support from someone who doesn't report to them — planning stakeholder outreach, building rapport with peers or leadership, sequencing an influence campaign, or drafting the actual outreach messages. Triggers on phrasing like 'get people on board with X,' 'how do I get buy-in,' 'pitch this to leadership,' or 'nobody's paying attention to this proposal.'"
---

# Influence Campaign

Guided workflow for introverted technical leaders who need buy-in, adoption, or support from people who don't report to them. Maps who matters, reads what each person responds to, sequences outreach, and drafts the actual messages — so the campaigning that doesn't come naturally gets done anyway.

## When this triggers

Use this skill when the user needs something from someone whose cooperation they can't compel. Simple test: **do you need permission or buy-in to do this?** If yes, this skill applies.

Explicit trigger phrases: "get people on board with X," "how do I get buy-in," "I want to pitch this to leadership," "nobody's paying attention to this proposal."

## State this skill maintains

Unlike a one-shot skill, this one keeps a persistent notes folder across sessions — see `references/file-formats.md` for the exact file layout and templates. On first-ever use, before anything else, locate or create that folder:

1. Look for `.influence-campaign-config` in the current directory and its parents.
2. If not found, ask the user where to keep notes (an existing Obsidian-style vault, a dedicated folder, or a repo subfolder), then write `.influence-campaign-config` there pointing at the chosen `<notes-root>`.
3. From then on, read `<notes-root>` from that config file — don't ask again.

## Mode dispatch

Run this on every trigger:

1. **No `<notes-root>/leader-profile.md`?** → Run **Mode 0: Leader Priming** (`references/leader-priming.md`) first — exactly once, ever. Once it's written, continue directly into step 2 without stopping.
2. **Otherwise** → Run **Mode 2: Influence Building** (`references/influence-building.md`). It handles both starting and resuming campaigns, and calls into **Mode 1: Rapport Mapping** (`references/rapport-mapping.md`) itself as its first step in both cases.

Background material both modes draw on: `references/influence-models.md` (Cohen & Bradford currencies, Cialdini, power/interest grid, RACI).

## Principles

- Reduce activation energy. Don't lecture about influence theory — produce the next concrete action and, when relevant, the drafted message.
- Respect the leader's own stated preferences and off-limits tactics from `leader-profile.md` over any generic playbook.
- Never fork a person's profile per-campaign. People are global (`people/`), campaigns are not (`campaigns/`) — see `references/file-formats.md`.
- Push back on vague goals. "Get people on board with X" isn't a campaign until there's a concrete definition of "adopted" and a deadline or forcing function.
```

- [ ] **Step 2: Run validate to confirm it currently fails (missing AUTHORS)**

Run: `bash scripts/validate.sh .` (from repo root)
Expected: `✗ influence-campaign: missing AUTHORS` and a non-zero exit (`Validation failed: 1 error(s)`)

- [ ] **Step 3: Write `influence-campaign/AUTHORS`**

```
Greg Weinger <gweinger@gmail.com>
Ryan Latta <ryan@ryanlatta.com>
```

- [ ] **Step 4: Run validate to confirm it now passes**

Run: `bash scripts/validate.sh .` (from repo root)
Expected: `✓ influence-campaign` and `All skills valid.` (exit 0)

- [ ] **Step 5: Commit**

```bash
git add influence-campaign/SKILL.md influence-campaign/AUTHORS
git commit -m "feat: scaffold influence-campaign skill (SKILL.md router + AUTHORS)"
```

---

### Task 2: `references/file-formats.md`

**Files:**
- Create: `influence-campaign/references/file-formats.md`

**Interfaces:**
- Consumes: pointer-file name/format from Task 1's `SKILL.md` (`.influence-campaign-config`, `notes_root: <path>`).
- Produces: exact template section headers relied on by later tasks — `# Leader Profile` fields (Task 4), `people/<slug>.md` fields including `## Interaction log (rolling summary)` and `Last touched base` (Tasks 5, 6), `campaigns/<slug>.md` fields including `## Interaction log (full detail)` (Task 6).

- [ ] **Step 1: Write `influence-campaign/references/file-formats.md`**

```markdown
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

One file per stakeholder, shared across all campaigns. `<slug>` is the person's name, lowercased, spaces replaced with `-` (e.g. `jane-vp-product.md`).

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
```

- [ ] **Step 2: Verify the file exists and has no placeholder markers (red before write, green after)**

Run before writing (should fail — file doesn't exist yet):
```bash
test -f influence-campaign/references/file-formats.md && echo EXISTS || echo MISSING
```
Expected: `MISSING`

Run after writing Step 1:
```bash
test -f influence-campaign/references/file-formats.md \
  && ! grep -iE "TBD|TODO|fill in later" influence-campaign/references/file-formats.md \
  && echo OK
```
Expected: `OK` (the bracketed `[...]` fields are template placeholders *for the skill to fill in at runtime*, not TODO markers left by us — they're intentional and covered by the spec's `file-formats.md` purpose, not a plan violation)

- [ ] **Step 3: Verify SKILL.md links to it**

Run: `grep -c "references/file-formats.md" influence-campaign/SKILL.md`
Expected: `2` (referenced once in "State this skill maintains" and once in "Principles")

- [ ] **Step 4: Commit**

```bash
git add influence-campaign/references/file-formats.md
git commit -m "feat: add influence-campaign file-formats reference"
```

---

### Task 3: `references/influence-models.md`

**Files:**
- Create: `influence-campaign/references/influence-models.md`

**Interfaces:**
- Produces: the priority order (leader preference > Cohen & Bradford > power/interest grid > Cialdini > RACI) consumed by Tasks 5 and 6.

- [ ] **Step 1: Write `influence-campaign/references/influence-models.md`**

```markdown
# Influence Models Reference

Background material the skill draws on. None of these are surfaced to the user as academic theory by default — they shape what the skill asks and recommends, not the vocabulary it uses out loud, unless the user wants to go there.

## Cohen & Bradford currencies of influence (no-preference fallback)

Used in Mode 1's "what do they respond to" question only when the leader has no stated preference in `leader-profile.md`. Categories to prompt with if the leader's answer is vague:

- **Inspiration-related:** vision, excellence, moral/ethical correctness
- **Task-related:** resources, assistance, information, cooperation
- **Position-related:** recognition, visibility, reputation, insider status
- **Relationship-related:** acceptance, personal support, understanding
- **Personal-related:** gratitude, ownership, self-concept

## Cialdini's principles (silent message-drafting checklist)

When drafting a message in Mode 2, silently check it against: reciprocity, commitment/consistency, social proof, liking, authority, scarcity. Don't force all six into one message — use whichever are honestly true of the situation.

## Power/interest grid (Mode 2 stakeholder mapping)

Place each stakeholder in scope on two axes — power to help/block the initiative, and interest in it — to identify: **deciders** (high power, high interest), **blockers** (high power, opposed), **swing votes** (high power, undecided/low interest so far), and **allies** (low power, high interest, worth keeping warm).

## RACI (optional clarifier only)

Only raise this when decision rights are genuinely unclear — ask "who's actually Accountable for signing off on this?" Don't run a full RACI exercise by default; it's overhead most campaigns don't need.

## Priority order

1. Leader's own familiar material (`leader-profile.md`) — always wins if stated.
2. Cohen & Bradford currencies — fallback for "what do they respond to."
3. Power/interest grid — always used for stakeholder mapping (not a fallback, this one's structural).
4. Cialdini — always silently checked in message drafting.
5. RACI — only on request or genuine ambiguity.
```

- [ ] **Step 2: Verify the file exists and has no placeholder markers**

```bash
test -f influence-campaign/references/influence-models.md \
  && ! grep -iE "TBD|TODO|fill in later" influence-campaign/references/influence-models.md \
  && echo OK
```
Expected: `OK`

- [ ] **Step 3: Verify SKILL.md links to it**

Run: `grep -c "references/influence-models.md" influence-campaign/SKILL.md`
Expected: `1`

- [ ] **Step 4: Commit**

```bash
git add influence-campaign/references/influence-models.md
git commit -m "feat: add influence-campaign influence-models reference"
```

---

### Task 4: `references/leader-priming.md`

**Files:**
- Create: `influence-campaign/references/leader-priming.md`

**Interfaces:**
- Consumes: `leader-profile.md` field list from Task 2 (`file-formats.md`) — the 8 interview questions below map 1:1 to those fields.
- Produces: the rule "familiar influence material overrides the Cohen & Bradford fallback," consumed by Tasks 3 (already stated), 5, and 6.

- [ ] **Step 1: Write `influence-campaign/references/leader-priming.md`**

```markdown
# Mode 0: Leader Priming

Runs exactly once, ever, the first time this skill triggers and `<notes-root>/leader-profile.md` doesn't exist yet. Never re-run once that file exists — later modes read it, they don't re-ask these questions.

Keep it light-touch — this is priming, not therapy. Ask these, in conversation rather than as a rigid form:

1. What's your preferred way to interact with peers or superiors?
2. When has face-to-face communication worked better for you than virtual, in your experience?
3. How have you successfully built rapport in the past?
4. What feels awkward, clumsy, or unnatural when you're building rapport with others?
5. Is building rapport and influence something you want to develop? (Flag honestly: doing this well will push outside the comfort zone — that's worth naming up front, not springing later.)
6. Is there influence-building material you're already familiar with that we can build on? (This answer, if given, overrides the Cohen & Bradford fallback everywhere downstream — see `references/influence-models.md`.)
7. Are there other sources of influence-building I should consider when giving recommendations?
8. What methods or techniques are out of bounds for you? (Record explicitly — later modes must never recommend these.)

Write the answers to `<notes-root>/leader-profile.md` using the template in `references/file-formats.md`. Once written, proceed directly into whatever mode originally triggered — don't stop after priming.
```

- [ ] **Step 2: Verify the file exists and has no placeholder markers**

```bash
test -f influence-campaign/references/leader-priming.md \
  && ! grep -iE "TBD|TODO|fill in later" influence-campaign/references/leader-priming.md \
  && echo OK
```
Expected: `OK`

- [ ] **Step 3: Verify SKILL.md links to it**

Run: `grep -c "references/leader-priming.md" influence-campaign/SKILL.md`
Expected: `1`

- [ ] **Step 4: Verify all 8 questions map to file-formats.md fields (manual cross-check)**

Run:
```bash
grep -oE '\*\*[A-Za-z /?.]+:\*\*' influence-campaign/references/file-formats.md | head -8
```
Expected: 8 bolded field labels (`Preferred interaction style`, `Face-to-face vs. virtual`, `Past rapport-building wins`, `What feels awkward/unnatural`, `Wants to stretch this skill?`, `Familiar influence material`, `Sources to consider when recommending`, `Off-limits methods`) — confirm each has a corresponding numbered question in `leader-priming.md` (it does, 1:1, per Step 1's content above).

- [ ] **Step 5: Commit**

```bash
git add influence-campaign/references/leader-priming.md
git commit -m "feat: add influence-campaign leader-priming reference (Mode 0)"
```

---

### Task 5: `references/rapport-mapping.md`

**Files:**
- Create: `influence-campaign/references/rapport-mapping.md`

**Interfaces:**
- Consumes: `people/<slug>.md` template fields from Task 2; priority order from Task 3.
- Produces: the "up-front checklist pass over every stakeholder in scope" behavior, consumed by Task 6's "Starting a new campaign" and "Resuming a campaign" steps.

- [ ] **Step 1: Write `influence-campaign/references/rapport-mapping.md`**

```markdown
# Mode 1: Rapport Mapping

Runs as an up-front checklist pass at the start or resumption of every campaign, over **every** stakeholder in that campaign's scope — not just newly-discovered people. Invoked by Mode 2 (`references/influence-building.md`), not triggered directly by `SKILL.md`.

For each stakeholder in scope, check `<notes-root>/people/<slug>.md`:

## No file exists

Run the full interview:

1. Name, title, area of responsibility
2. What they respond to / working style (prompt with Cohen & Bradford currencies from `references/influence-models.md` only if the leader's own answer is vague, and only if `leader-profile.md` has no overriding preference)
3. Who they have a positive relationship with
4. Who they have a negative relationship with
5. The leader's own relationship with them — positive/negative, shared history, key moments that shape it so far

Write the answers to `people/<slug>.md` using the template in `references/file-formats.md`, setting `Last touched base` to today's date. `<slug>` is the person's name, lowercased, spaces replaced with hyphens.

## File already exists

Don't re-run the full interview. Ask only: "Anything changed with [name] since we last touched base?" If the answer surfaces something new, update the relevant field(s) in their existing file — don't overwrite the whole file, and don't touch the interaction log (that's Mode 2's job).

## After the pass

Once every stakeholder in scope has either a fresh file or a confirmed "nothing changed," return control to Mode 2 (`references/influence-building.md`) to continue the campaign.
```

- [ ] **Step 2: Verify the file exists and has no placeholder markers**

```bash
test -f influence-campaign/references/rapport-mapping.md \
  && ! grep -iE "TBD|TODO|fill in later" influence-campaign/references/rapport-mapping.md \
  && echo OK
```
Expected: `OK`

- [ ] **Step 3: Verify SKILL.md links to it**

Run: `grep -c "references/rapport-mapping.md" influence-campaign/SKILL.md`
Expected: `1`

- [ ] **Step 4: Commit**

```bash
git add influence-campaign/references/rapport-mapping.md
git commit -m "feat: add influence-campaign rapport-mapping reference (Mode 1)"
```

---

### Task 6: `references/influence-building.md`

**Files:**
- Create: `influence-campaign/references/influence-building.md`

**Interfaces:**
- Consumes: `campaigns/<slug>.md` and `people/<slug>.md` template fields (Task 2, including exact headings `## Interaction log (full detail)` and `## Interaction log (rolling summary)`); power/interest grid and Cialdini checklist (Task 3); Mode 1 hand-off contract (Task 5).
- Produces: nothing further consumed — this is the terminal reference file.

- [ ] **Step 1: Write `influence-campaign/references/influence-building.md`**

```markdown
# Mode 2: Influence Building

The campaign engine. Entry point depends on whether the campaign already has a file.

## Starting a new campaign

1. Identify the initiative and ask for a concrete win condition — if the user's framing is vague ("get people on board with X"), push back until there's an actual definition of "adopted" and a deadline or forcing function. Don't proceed to mapping until this is concrete.
2. Identify the stakeholder subset using the power/interest grid (`references/influence-models.md`).
3. Hand off to Mode 1 (`references/rapport-mapping.md`) to run the checklist pass over that subset.
4. Build one simple narrative for the campaign — the value, told through a concrete example, not an abstraction.
5. Create `campaigns/<slug>.md` using the template in `references/file-formats.md`, with the win condition, deadline, stakeholders, power/interest placement, and narrative filled in. `<slug>` is the initiative name, lowercased, spaces replaced with hyphens.

## Resuming a campaign

1. If the user's message names the initiative, read that campaign's file directly. If it's ambiguous and more than one `campaigns/*.md` file exists, list the open campaigns and ask which one applies — don't guess.
2. Read the campaign file plus every relevant `people/*.md` file.
3. Run Mode 1's checklist pass (`references/rapport-mapping.md`) over the stakeholders in scope — existing-file people just get the "anything changed" check.
4. Ask: "Anything new happened — email, meeting, conversation — since last time?" Treat the answer as a pivot point against the existing plan, not a fresh start.

## Recommending a move

Each turn, recommend 2–3 sized options for the single next-best person to move on — for example "quick Slack DM," "coffee invite," or "wait for a natural opening." Calibrate the sizing against the leader's comfort/stretch preference in `leader-profile.md`: don't default to the most aggressive option for a leader who flagged low stretch tolerance, and don't undersell it for one who said they want to be pushed.

This is always an options menu, never a single prescriptive recommendation — the leader picks.

## Drafting the message

Once the leader picks a move that involves a message, draft the actual first-pass text using:
- That person's currency/working-style read from `people/<slug>.md`
- The campaign's narrative from `campaigns/<slug>.md`
- A silent Cialdini check from `references/influence-models.md`

Show the draft, don't just describe it.

## Logging the outcome

After the leader acts (or reports back), log per the dual-write rule in `references/file-formats.md`:
- Full detail (what was said, outcome, next step) → that campaign's `## Interaction log (full detail)` section
- One rolling-summary line → that person's `## Interaction log (rolling summary)` section, plus update their `Last touched base` date
```

- [ ] **Step 2: Verify the file exists and has no placeholder markers**

```bash
test -f influence-campaign/references/influence-building.md \
  && ! grep -iE "TBD|TODO|fill in later" influence-campaign/references/influence-building.md \
  && echo OK
```
Expected: `OK`

- [ ] **Step 3: Verify SKILL.md links to it**

Run: `grep -c "references/influence-building.md" influence-campaign/SKILL.md`
Expected: `1`

- [ ] **Step 4: Verify heading names match file-formats.md exactly**

```bash
grep -o "Interaction log (full detail)" influence-campaign/references/influence-building.md influence-campaign/references/file-formats.md
grep -o "Interaction log (rolling summary)" influence-campaign/references/influence-building.md influence-campaign/references/file-formats.md
```
Expected: both commands print two matching lines (one per file) — confirms no drift between the two files' section-heading names.

- [ ] **Step 5: Commit**

```bash
git add influence-campaign/references/influence-building.md
git commit -m "feat: add influence-campaign influence-building reference (Mode 2)"
```

---

### Task 7: Final integration — validate, dist, README check

**Files:**
- Modify: none expected (verification only; only touch `README.md` if Step 3 finds a mismatch)

**Interfaces:**
- Consumes: the complete skill package from Tasks 1–6.

- [ ] **Step 1: Run full validation**

Run: `make validate`
Expected: includes `✓ influence-campaign` among the output lines, and `All skills valid.` with exit 0.

- [ ] **Step 2: Run packaging**

Run: `make dist`
Expected: `dist/influence-campaign.skill` is created; command prints `✓ dist/influence-campaign.skill`; exit 0.

- [ ] **Step 3: Verify README's skills table matches the AUTHORS file**

```bash
grep "influence-campaign" README.md
cat influence-campaign/AUTHORS
```
Expected: README row shows `Greg Weinger & Ryan Latta` as authors, matching the two names in `AUTHORS`. No edit needed if they already match (they do, per the row present before this plan started) — only edit `README.md` if this check reveals a mismatch.

- [ ] **Step 4: Confirm the packaged zip contains all expected files**

```bash
unzip -l dist/influence-campaign.skill
```
Expected: listing includes `influence-campaign/SKILL.md`, `influence-campaign/AUTHORS`, and all five files under `influence-campaign/references/`.

- [ ] **Step 5: Commit (only if Step 3 required a README edit; otherwise skip — nothing to commit)**

```bash
git add README.md
git commit -m "docs: sync influence-campaign README authors"
```

---

### Task 8: Manual demo-scenario walkthrough

This task has no automated test — it's the acceptance check described in the spec's "Demo / Test Scenario" section, run by a human (or agent) driving a live Claude conversation with the finished skill loaded. Document the run, don't skip it.

**Files:**
- Create (optional, for the record): `influence-campaign/references/demo-scenario-notes.md` — a short log of what happened during the walkthrough, kept only if useful for future regression checks.

- [ ] **Step 1: Set up the scenario**

Start a fresh conversation with the `influence-campaign` skill available. Prompt: "I need to get buy-in for a platform migration. I need sign-off from Jane, our VP of Product — she loves talking about product. There's also Mark, a skeptical staff engineer who's a swing vote, and Priya, a peer EM who's already an ally."

Expected: since this is the first-ever trigger, Mode 0 (Leader Priming) runs first, asking the 8 questions from `references/leader-priming.md`, before anything about the campaign.

- [ ] **Step 2: Confirm leader-profile.md is written correctly**

```bash
cat <notes-root>/leader-profile.md
```
Expected: all 8 fields from the template in `references/file-formats.md` are populated with real answers, no placeholder brackets remaining.

- [ ] **Step 3: Confirm Rapport Mapping runs for Jane and Mark, skips deep-interview for Priya if she's pre-existing**

Expected: full interviews (5 questions each) run for Jane and Mark since they have no files yet; if Priya already has a file from an earlier test run, only "anything changed with Priya" is asked.

- [ ] **Step 4: Confirm the campaign file is created with a concrete win condition**

```bash
cat <notes-root>/campaigns/platform-migration.md
```
Expected: `Win condition` and `Deadline / forcing function` are concrete (not left vague), `Stakeholders` lists Jane/Mark/Priya with power/interest placement, `Narrative` is a concrete example, not an abstraction.

- [ ] **Step 5: Confirm a next-move recommendation is an options menu, sized to the leader's stated stretch preference**

Expected: 2–3 sized options offered for one specific next person, not a single prescriptive move; sizing matches whatever stretch/comfort answer was given in Step 1's Leader Priming interview.

- [ ] **Step 6: Confirm message drafting uses Jane's currency read**

Ask the skill to draft the outreach to Jane. Expected: draft leads with product (matching "loves talking about product"), not a generic template.

- [ ] **Step 7: Confirm resumption a week later picks up state correctly**

Start a new conversation: "Resuming the platform migration campaign — I had a call with Mark yesterday, he raised concerns about rollout risk." Expected: skill reads the existing campaign + people files (no re-interview), treats the call as a pivot, and updates both the campaign's full-detail log and Mark's rolling-summary log per the dual-write rule.

- [ ] **Step 8 (optional): Record results and commit**

If you kept `demo-scenario-notes.md`:
```bash
git add influence-campaign/references/demo-scenario-notes.md
git commit -m "docs: record influence-campaign demo walkthrough results"
```
