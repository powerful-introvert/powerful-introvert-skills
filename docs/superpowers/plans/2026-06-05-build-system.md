# Build System Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `make validate` and `make dist` targets to validate skill folder structure and package each skill as a `.skill` zip archive.

**Architecture:** Makefile is the interface; `scripts/validate.sh` and `scripts/dist.sh` hold the logic. Both accept an optional repo-root argument (default: `.`) so tests can run against fixture directories in isolation. `dist` depends on `validate` so broken skills can never be packaged.

**Tech Stack:** GNU Make, bash, zip (macOS built-in), awk, grep

---

### Task 1: .gitignore

**Files:**
- Create: `.gitignore`

- [ ] **Step 1: Create .gitignore**

```
dist/
```

- [ ] **Step 2: Commit**

```bash
git add .gitignore
git commit -m "chore: gitignore dist/"
```

---

### Task 2: Test runner

**Files:**
- Create: `tests/run_tests.sh`

- [ ] **Step 1: Create tests/run_tests.sh**

```bash
#!/usr/bin/env bash
# Runs all test_*.sh files in tests/. Exits 0 if all pass.
set -uo pipefail
PASS=0; FAIL=0

for f in "$(dirname "$0")"/test_*.sh; do
    echo "--- $f"
    if bash "$f"; then
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
    fi
done

echo ""
echo "Results: $PASS suite(s) passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
```

- [ ] **Step 2: Make executable**

```bash
chmod +x tests/run_tests.sh
```

- [ ] **Step 3: Commit**

```bash
git add tests/run_tests.sh
git commit -m "test: add test runner"
```

---

### Task 3: validate.sh — file presence checks

**Files:**
- Create: `tests/test_validate.sh`
- Create: `scripts/validate.sh`

- [ ] **Step 1: Write failing tests**

Create `tests/test_validate.sh`:

```bash
#!/usr/bin/env bash
set -uo pipefail
SCRIPT="$(cd "$(dirname "$0")/.." && pwd)/scripts/validate.sh"
PASS=0; FAIL=0

assert() {
    local desc="$1" expected="$2"
    shift 2
    local output code
    output=$("$@" 2>&1; echo "EXIT:$?") || true
    code="${output##*EXIT:}"
    if [ "$code" = "$expected" ]; then
        echo "  ✓ $desc"
        PASS=$((PASS + 1))
    else
        echo "  ✗ $desc (expected exit $expected, got $code)"
        FAIL=$((FAIL + 1))
    fi
}

make_fixture() {
    TMPDIR=$(mktemp -d)
    cat > "$TMPDIR/README.md" <<'EOF'
| Skill | What |
|---|---|
| `valid-skill` | A valid skill |
EOF
    mkdir -p "$TMPDIR/valid-skill"
    cat > "$TMPDIR/valid-skill/SKILL.md" <<'EOF'
---
name: valid-skill
description: A valid skill for testing
---
Content here.
EOF
    echo "Greg Weinger <greg@example.com>" > "$TMPDIR/valid-skill/AUTHORS"
}

# Test: valid skill passes
make_fixture
assert "valid skill passes" 0 bash "$SCRIPT" "$TMPDIR"
rm -rf "$TMPDIR"

# Test: missing AUTHORS fails
make_fixture
rm "$TMPDIR/valid-skill/AUTHORS"
assert "missing AUTHORS fails" 1 bash "$SCRIPT" "$TMPDIR"
rm -rf "$TMPDIR"

# Test: folder without SKILL.md is not treated as a skill
make_fixture
mkdir -p "$TMPDIR/not-a-skill"
assert "folder without SKILL.md is ignored" 0 bash "$SCRIPT" "$TMPDIR"
rm -rf "$TMPDIR"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
```

- [ ] **Step 2: Make executable and confirm it fails**

```bash
chmod +x tests/test_validate.sh
bash tests/test_validate.sh
```

Expected: error — `scripts/validate.sh: No such file or directory`

- [ ] **Step 3: Create scripts/validate.sh with file presence checks**

```bash
#!/usr/bin/env bash
# Usage: validate.sh [repo_root]
set -uo pipefail
REPO_ROOT="${1:-.}"
ERRORS=0

for dir in "$REPO_ROOT"/*/; do
    [ -d "$dir" ] || continue
    [ -f "$dir/SKILL.md" ] || continue
    slug=$(basename "$dir")
    skill_errors=0

    if [ ! -f "$dir/AUTHORS" ]; then
        echo "  ✗ $slug: missing AUTHORS"
        skill_errors=$((skill_errors + 1))
    fi

    if [ "$skill_errors" -eq 0 ]; then
        echo "  ✓ $slug"
    fi
    ERRORS=$((ERRORS + skill_errors))
done

if [ "$ERRORS" -gt 0 ]; then
    echo "Validation failed: $ERRORS error(s)"
    exit 1
fi
echo "All skills valid."
```

- [ ] **Step 4: Make executable**

```bash
chmod +x scripts/validate.sh
```

- [ ] **Step 5: Run tests — expect pass**

```bash
bash tests/test_validate.sh
```

Expected:
```
  ✓ valid skill passes
  ✓ missing AUTHORS fails
  ✓ folder without SKILL.md is ignored

Results: 3 passed, 0 failed
```

- [ ] **Step 6: Commit**

```bash
git add scripts/validate.sh tests/test_validate.sh
git commit -m "feat: validate.sh — file presence checks"
```

---

### Task 4: validate.sh — frontmatter checks

**Files:**
- Modify: `scripts/validate.sh`
- Modify: `tests/test_validate.sh`

- [ ] **Step 1: Add failing tests**

Append to `tests/test_validate.sh` before the final `echo` and `[ "$FAIL" -eq 0 ]`:

```bash
# Test: SKILL.md missing name: fails
make_fixture
cat > "$TMPDIR/valid-skill/SKILL.md" <<'EOF'
---
description: A skill without a name
---
Content.
EOF
assert "missing name: in frontmatter fails" 1 bash "$SCRIPT" "$TMPDIR"
rm -rf "$TMPDIR"

# Test: SKILL.md missing description: fails
make_fixture
cat > "$TMPDIR/valid-skill/SKILL.md" <<'EOF'
---
name: valid-skill
---
Content.
EOF
assert "missing description: in frontmatter fails" 1 bash "$SCRIPT" "$TMPDIR"
rm -rf "$TMPDIR"
```

- [ ] **Step 2: Run tests — expect 2 new failures**

```bash
bash tests/test_validate.sh
```

Expected: 3 passed, 2 failed.

- [ ] **Step 3: Add frontmatter check to scripts/validate.sh**

Replace the full contents of `scripts/validate.sh`:

```bash
#!/usr/bin/env bash
# Usage: validate.sh [repo_root]
set -uo pipefail
REPO_ROOT="${1:-.}"
ERRORS=0

has_frontmatter_key() {
    local file="$1" key="$2"
    awk 'BEGIN{found=0} /^---/{found++; next} found==1 && /^'"$key"':/{exit 0} END{exit 1}' "$file"
}

for dir in "$REPO_ROOT"/*/; do
    [ -d "$dir" ] || continue
    [ -f "$dir/SKILL.md" ] || continue
    slug=$(basename "$dir")
    skill_errors=0

    if [ ! -f "$dir/AUTHORS" ]; then
        echo "  ✗ $slug: missing AUTHORS"
        skill_errors=$((skill_errors + 1))
    fi

    if ! has_frontmatter_key "$dir/SKILL.md" "name"; then
        echo "  ✗ $slug: SKILL.md missing 'name:' in frontmatter"
        skill_errors=$((skill_errors + 1))
    fi

    if ! has_frontmatter_key "$dir/SKILL.md" "description"; then
        echo "  ✗ $slug: SKILL.md missing 'description:' in frontmatter"
        skill_errors=$((skill_errors + 1))
    fi

    if [ "$skill_errors" -eq 0 ]; then
        echo "  ✓ $slug"
    fi
    ERRORS=$((ERRORS + skill_errors))
done

if [ "$ERRORS" -gt 0 ]; then
    echo "Validation failed: $ERRORS error(s)"
    exit 1
fi
echo "All skills valid."
```

- [ ] **Step 4: Run tests — expect all pass**

```bash
bash tests/test_validate.sh
```

Expected:
```
  ✓ valid skill passes
  ✓ missing AUTHORS fails
  ✓ folder without SKILL.md is ignored
  ✓ missing name: in frontmatter fails
  ✓ missing description: in frontmatter fails

Results: 5 passed, 0 failed
```

- [ ] **Step 5: Commit**

```bash
git add scripts/validate.sh tests/test_validate.sh
git commit -m "feat: validate.sh — frontmatter checks (name, description)"
```

---

### Task 5: validate.sh — README sync check

**Files:**
- Modify: `scripts/validate.sh`
- Modify: `tests/test_validate.sh`

- [ ] **Step 1: Add failing test**

Append to `tests/test_validate.sh` before the final `echo`:

```bash
# Test: skill slug not in README fails
make_fixture
mkdir -p "$TMPDIR/unlisted-skill"
cat > "$TMPDIR/unlisted-skill/SKILL.md" <<'EOF'
---
name: unlisted-skill
description: A skill missing from the README table
---
Content.
EOF
echo "Greg Weinger <greg@example.com>" > "$TMPDIR/unlisted-skill/AUTHORS"
assert "skill not in README fails" 1 bash "$SCRIPT" "$TMPDIR"
rm -rf "$TMPDIR"
```

- [ ] **Step 2: Run tests — expect 1 new failure**

```bash
bash tests/test_validate.sh
```

Expected: 5 passed, 1 failed.

- [ ] **Step 3: Add README check to scripts/validate.sh**

Inside the skill loop in `scripts/validate.sh`, add after the `has_frontmatter_key "description"` block:

```bash
    if [ -f "$REPO_ROOT/README.md" ] && ! grep -q "\`$slug\`" "$REPO_ROOT/README.md"; then
        echo "  ✗ $slug: not found in README.md skills table"
        skill_errors=$((skill_errors + 1))
    fi
```

- [ ] **Step 4: Run tests — expect all pass**

```bash
bash tests/test_validate.sh
```

Expected:
```
  ✓ valid skill passes
  ✓ missing AUTHORS fails
  ✓ folder without SKILL.md is ignored
  ✓ missing name: in frontmatter fails
  ✓ missing description: in frontmatter fails
  ✓ skill not in README fails

Results: 6 passed, 0 failed
```

- [ ] **Step 5: Commit**

```bash
git add scripts/validate.sh tests/test_validate.sh
git commit -m "feat: validate.sh — README sync check"
```

---

### Task 6: Makefile

**Files:**
- Create: `Makefile`

- [ ] **Step 1: Create Makefile**

```makefile
.PHONY: all validate dist clean test

all: validate dist

validate:
	@bash scripts/validate.sh .

dist: validate
	@bash scripts/dist.sh .

test:
	@bash tests/run_tests.sh

clean:
	rm -rf dist/
```

- [ ] **Step 2: Run make validate (no skills in repo yet)**

```bash
make validate
```

Expected: `All skills valid.`

- [ ] **Step 3: Run make test**

```bash
make test
```

Expected: all 6 validate tests pass.

- [ ] **Step 4: Commit**

```bash
git add Makefile
git commit -m "feat: Makefile — validate, dist, clean, test, all targets"
```

---

### Task 7: dist.sh

**Files:**
- Create: `scripts/dist.sh`
- Create: `tests/test_dist.sh`

- [ ] **Step 1: Write failing tests**

Create `tests/test_dist.sh`:

```bash
#!/usr/bin/env bash
set -uo pipefail
DIST="$(cd "$(dirname "$0")/.." && pwd)/scripts/dist.sh"
PASS=0; FAIL=0

assert() {
    local desc="$1" expected="$2"
    shift 2
    "$@" >/dev/null 2>&1
    local code=$?
    if [ "$code" = "$expected" ]; then
        echo "  ✓ $desc"
        PASS=$((PASS + 1))
    else
        echo "  ✗ $desc (expected exit $expected, got $code)"
        FAIL=$((FAIL + 1))
    fi
}

make_fixture() {
    TMPDIR=$(mktemp -d)
    cat > "$TMPDIR/README.md" <<'EOF'
| Skill | What |
|---|---|
| `sample-skill` | A sample skill |
EOF
    mkdir -p "$TMPDIR/sample-skill"
    cat > "$TMPDIR/sample-skill/SKILL.md" <<'EOF'
---
name: sample-skill
description: A sample skill for dist testing
---
Content.
EOF
    echo "Greg Weinger <greg@example.com>" > "$TMPDIR/sample-skill/AUTHORS"
}

# Test: creates .skill file
make_fixture
bash "$DIST" "$TMPDIR"
assert "dist creates .skill file" 0 test -f "$TMPDIR/dist/sample-skill.skill"
rm -rf "$TMPDIR"

# Test: .skill is a valid zip
make_fixture
bash "$DIST" "$TMPDIR"
assert ".skill is a valid zip" 0 unzip -t "$TMPDIR/dist/sample-skill.skill"
rm -rf "$TMPDIR"

# Test: zip contains SKILL.md
make_fixture
bash "$DIST" "$TMPDIR"
assert "zip contains SKILL.md" 0 bash -c "unzip -Z1 '$TMPDIR/dist/sample-skill.skill' | grep -q 'SKILL.md'"
rm -rf "$TMPDIR"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
```

- [ ] **Step 2: Make executable and confirm failure**

```bash
chmod +x tests/test_dist.sh
bash tests/test_dist.sh
```

Expected: error — `scripts/dist.sh: No such file or directory`

- [ ] **Step 3: Create scripts/dist.sh**

```bash
#!/usr/bin/env bash
# Usage: dist.sh [repo_root]
set -uo pipefail
REPO_ROOT="${1:-.}"
mkdir -p "$REPO_ROOT/dist"

for dir in "$REPO_ROOT"/*/; do
    [ -d "$dir" ] || continue
    [ -f "$dir/SKILL.md" ] || continue
    slug=$(basename "$dir")
    (cd "$REPO_ROOT" && zip -r "dist/$slug.skill" "$slug/" -x "*/.DS_Store" -q)
    echo "  ✓ dist/$slug.skill"
done
```

- [ ] **Step 4: Make executable**

```bash
chmod +x scripts/dist.sh
```

- [ ] **Step 5: Run tests — expect all pass**

```bash
bash tests/test_dist.sh
```

Expected:
```
  ✓ dist creates .skill file
  ✓ .skill is a valid zip
  ✓ zip contains SKILL.md

Results: 3 passed, 0 failed
```

- [ ] **Step 6: Run full test suite**

```bash
make test
```

Expected: both suites pass (6 validate + 3 dist).

- [ ] **Step 7: Commit**

```bash
git add scripts/dist.sh tests/test_dist.sh
git commit -m "feat: dist.sh — package skills as .skill zip archives"
```

---

### Task 8: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

- [ ] **Step 1: Replace the "No Build System" section with build commands**

Find the section that starts with `## No Build System` and replace it with:

```markdown
## Build

```bash
make validate   # check all skills for correct structure
make dist       # package each skill as dist/<name>.skill (runs validate first)
make test       # run the test suite
make clean      # remove dist/
```

Validate checks: `SKILL.md` and `AUTHORS` present; `SKILL.md` frontmatter has `name:` and `description:`; slug appears in README.md skills table.

`dist/` is gitignored. Scripts accept an optional repo-root argument — `bash scripts/validate.sh /some/path` — which is how the test suite runs them against fixture directories.
```

- [ ] **Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: add build commands to CLAUDE.md"
```
