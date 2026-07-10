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
3. Run Mode 1's checklist pass (`references/rapport-mapping.md`), scoped to whichever stakeholders the user's message names or clearly implicates (e.g. "I had a call with Mark" → just Mark) — existing-file people just get the "anything changed" check. Fall back to the full stakeholder roster only if the user asks for a full status sweep or doesn't name anyone specific.
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
