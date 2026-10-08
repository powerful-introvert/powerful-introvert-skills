# Powerful Introvert — Skills for Introverted Technology Leaders

Free, open-source [Claude Skills](https://docs.claude.com) for engineering managers, product managers, and individual contributors who want to lead and influence without emptying their social battery.

Each skill is a self-contained scaffold for a high-leverage move that introverted leaders tend to know they should make — and skip. The goal isn't to make you act like an extrovert. It's to lower the activation energy on the right move and hand you something concrete: the right message, agenda, action plan.

These skills come out of [*The Introverted Leader*](https://gweinger.com) podcast, published by Powerful Introvert LLC, and are released openly so you can use them, adapt them, and fold them into your own workflow.

---

## Skills in this set

| Skill | What it does | Authors |
|---|---|---|
| [`influence-campaign`](./influence-campaign/) | Plan and run an influence campaign for an initiative: map stakeholders, read what each responds to, sequence outreach, draft the messages. Remembers the people you work with across campaigns. | Greg Weinger & Ryan Latta |

**Coming next:** feedback on a meeting from its transcript, prep for a difficult conversation, a pre-meeting ritual, and a survival plan for offsites and conferences. Watch or star the repo to hear when they land.

> **Attribution model:** authorship is declared per skill, not per repo. A solo skill credits its author; a co-authored skill credits everyone. The credit lives in the skill's folder (`AUTHORS` and the `SKILL.md`), so it travels with the skill if someone copies just that folder.

---

## How to use a skill

Each skill is a folder containing a `SKILL.md` (the instructions Claude reads) plus any supporting files. To use one:

1. Copy the skill folder into your Claude environment's skills directory, **or** package it as a `.skill` file (`make dist`) and install it.
2. Start a conversation and describe your situation — the skill triggers automatically when your request matches what it's for. For `influence-campaign`, try: *"I need buy-in from leadership on a proposal, and nobody's paying attention."*

Skills are not Claude-specific in concept, but these are written and tested against Claude.

---

## About the authors

**Greg Weinger** has over 25 years of leadership experience, from engineer to manager to SVP of Product — an introvert who was once told he didn't have the temperament for director. He hosts [*The Introverted Leader*](https://gweinger.com), the podcast for introverted leaders who want to get promoted without becoming someone else.

**Ryan Latta** <!-- TODO: one-line bio from Ryan --> — [ryanlatta.com](https://ryanlatta.com). Ryan co-designed `influence-campaign` and is a guest on *The Introverted Leader* (episode #90, November 2, 2026).

---

## Want help putting this into practice?

Doing great work and still getting passed over? Going quiet in the meetings that decide your reputation? [Answer six quick questions](QUESTIONNAIRE_URL) — if I think I can help, I'll reach out personally. — Greg

---

## License

Code and skill instructions in this repository are licensed under the **Apache License 2.0** — see [`LICENSE`](./LICENSE). You may use, modify, and redistribute them, including commercially.

Apache 2.0 (rather than MIT) is used deliberately: it includes an express patent grant from each contributor, which matters for a co-authored, openly shared project.

> **Note on prose:** the bulk of a skill is written guidance. If you reuse substantial written content elsewhere, please keep the attribution. (If we decide it matters, we may dual-license the prose under CC-BY-4.0 — see `NOTICE`.)

---

## Contributing

See [`CONTRIBUTING.md`](./CONTRIBUTING.md). Short version: by contributing, you agree to license your contribution under Apache 2.0, and you'll be credited in the relevant skill's `AUTHORS` file.
