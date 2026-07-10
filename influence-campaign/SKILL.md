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
