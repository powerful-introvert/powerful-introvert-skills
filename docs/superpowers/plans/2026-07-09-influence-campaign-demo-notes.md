# Demo Scenario Walkthrough — Results Log

Run 2026-07-09, simulated single-session walkthrough (task 8 of the influence-campaign build plan). Scenario: platform migration needing sign-off from Jane (VP Product), Mark (skeptical staff eng, swing vote), Priya (peer EM, ally).

## Pass/fail summary

| Step | Check | Result |
|---|---|---|
| 1 | Mode 0 (Leader Priming) runs first, asks all 8 questions before campaign talk | PASS |
| 2 | `leader-profile.md` written with all 8 fields, no placeholders | PASS |
| 3 | Full 5-question rapport interviews for stakeholders with no file; "anything changed" only for existing files | PASS (see deviation below) |
| 4 | `campaigns/<slug>.md` written with concrete win condition, deadline, stakeholder power/interest, concrete narrative | PASS |
| 5 | Next-move recommendation is a 2–3 option menu sized to stated stretch preference | PASS |
| 6 | Outreach draft to Jane leads with product framing, not generic | PASS |
| 7 | Resumed session reads existing files (no re-interview), treats new info as a pivot, dual-writes to both campaign log and person's rolling-summary log + Last touched base | PASS |

## Deviations / notes

- **Step 3 framing mismatch:** the task brief describes Jane and Mark as "new" and treats Priya as potentially "already existing," but in a genuinely fresh run all three stakeholders lack a `people/*.md` file, so all three get full interviews — that's correct per `rapport-mapping.md`'s own logic ("No file exists" branch applies to anyone without a file). Exercised the "file already exists" branch separately in a deliberate second mini-pass on Priya: only asked "anything changed," updated one field in place, left the interaction log untouched. Confirmed working.

## Skill-quality issues found

1. **Ambiguous scope for "checklist pass" on resume.** `influence-building.md`'s "Resuming a campaign" step 3 says to run Mode 1's checklist pass "over the stakeholders in scope" — read literally, this means asking "anything changed with Jane / Mark / Priya" every single time a campaign resumes, even when the user's message is clearly about only one person (e.g. "I had a call with Mark"). For a campaign with many stakeholders over many sessions this could become repetitive friction the skill is explicitly trying to avoid causing (see SKILL.md's "reduce activation energy" principle). Worth clarifying whether the checklist pass should be scoped down to only the people implicated by the user's resume message, rather than the full campaign roster, every time.
2. **No hard format specified for interaction-log lines.** `file-formats.md`'s one example rolling-summary line (`2026-07-01 — outreach re: platform-migration, positive`) implies a loose convention (date — context — valence) but doesn't mandate a shape. Not blocking, but a future regression check should watch for drift in how these lines get formatted across sessions/models.

No genuine contradictions were found that blocked any step. Dispatch logic in SKILL.md → leader-priming.md → influence-building.md → rapport-mapping.md → back to influence-building.md ran cleanly end to end, including the dual-write rule on resume.
