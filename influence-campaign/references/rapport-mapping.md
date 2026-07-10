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
