# Contributing

Thanks for your interest in contributing to this skill set.

## Licensing of contributions

By submitting a contribution (a pull request, a patch, or content added
directly), **you agree to license your contribution under the Apache
License 2.0**, the same license that covers this repository. This is the
project's lightweight inbound = outbound agreement; there is no separate
CLA to sign.

If you contribute substantial written content and the project has adopted
the optional prose dual-license (see `NOTICE`), your written content is
also offered under CC-BY-4.0 with attribution to you.

## Attribution

Authorship is tracked **per skill**, not per repository.

- Each skill folder contains an `AUTHORS` file.
- If you create a new skill, add yourself to that skill's `AUTHORS`.
- If you make a meaningful contribution to an existing skill, add yourself
  to that skill's `AUTHORS`.
- Update the summary table in the top-level `README.md` to match.

Example `AUTHORS` file for a co-authored skill:

```
Greg Weinger <greg@example.com>
Ryan Latta <ryan@example.com>
```

## Adding a new skill

A skill is a folder. At minimum it contains:

```
skill-name/
├── SKILL.md     (required — YAML frontmatter with name + description, then instructions)
└── AUTHORS      (who made it)
```

Optionally, it may include `scripts/`, `references/`, and `assets/`
subfolders. Keep `SKILL.md` focused; push long reference material into
`references/` and point to it from `SKILL.md`.

## Style

Plain, direct, first-person where it fits. These skills are for busy,
competent people — reduce activation energy, produce a concrete artifact,
don't lecture.
