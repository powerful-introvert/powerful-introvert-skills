# Build System Design

**Date:** 2026-06-04  
**Status:** Approved

## Overview

A lightweight Makefile + shell script build system for validating skill structure and packaging skills as distributable `.skill` zip archives. No external dependencies.

## Makefile Targets

| Target | Behavior |
|---|---|
| `make validate` | Run `scripts/validate.sh`; exits non-zero on any failure |
| `make dist` | Depends on `validate`; runs `scripts/dist.sh` |
| `make clean` | Remove `dist/` |
| `make all` | `validate` + `dist` |

`dist` depends on `validate` so broken skills can never be packaged.

## validate.sh

For each top-level directory containing a `SKILL.md`:

1. `SKILL.md` exists — error if missing
2. `AUTHORS` exists — error if missing
3. `SKILL.md` frontmatter contains `name:` and `description:` — parsed between `---` markers using `awk`
4. Folder slug appears in the README.md skills table — checked with `grep`

Prints a pass/fail line per skill. Exits 0 if all pass, 1 if any fail.

## dist.sh

For each skill folder:

1. Create `dist/` if it doesn't exist
2. `zip -r dist/<skill-name>.skill <skill-name>/`
3. Print: `✓ dist/<skill-name>.skill`

Output format is `dist/<name>.skill` (zip). No manifest or version stamping in this version.

## Directory Layout After Build

```
dist/
  influence-campaign.skill
  meeting-prep.skill
  ...
scripts/
  validate.sh
  dist.sh
Makefile
```

`dist/` is gitignored.
