#!/usr/bin/env bash
set -uo pipefail
SCRIPT="$(cd "$(dirname "$0")/.." && pwd)/scripts/validate.sh"
PASS=0; FAIL=0
FIXTURE=""

cleanup() { [ -n "$FIXTURE" ] && rm -rf "$FIXTURE"; }
trap cleanup EXIT

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
    FIXTURE=$(mktemp -d)
    cat > "$FIXTURE/README.md" <<'EOF'
| Skill | What |
|---|---|
| `valid-skill` | A valid skill |
EOF
    mkdir -p "$FIXTURE/valid-skill"
    cat > "$FIXTURE/valid-skill/SKILL.md" <<'EOF'
---
name: valid-skill
description: A valid skill for testing
---
Content here.
EOF
    echo "Greg Weinger <greg@example.com>" > "$FIXTURE/valid-skill/AUTHORS"
}

# Test: valid skill passes
make_fixture
assert "valid skill passes" 0 bash "$SCRIPT" "$FIXTURE"
rm -rf "$FIXTURE"; FIXTURE=""

# Test: missing AUTHORS fails
make_fixture
rm "$FIXTURE/valid-skill/AUTHORS"
assert "missing AUTHORS fails" 1 bash "$SCRIPT" "$FIXTURE"
rm -rf "$FIXTURE"; FIXTURE=""

# Test: folder without SKILL.md is not treated as a skill
make_fixture
mkdir -p "$FIXTURE/not-a-skill"
assert "folder without SKILL.md is ignored" 0 bash "$SCRIPT" "$FIXTURE"
rm -rf "$FIXTURE"; FIXTURE=""

# Test: SKILL.md missing name: fails
make_fixture
cat > "$FIXTURE/valid-skill/SKILL.md" <<'EOF'
---
description: A skill without a name
---
Content.
EOF
assert "missing name: in frontmatter fails" 1 bash "$SCRIPT" "$FIXTURE"
rm -rf "$FIXTURE"; FIXTURE=""

# Test: SKILL.md missing description: fails
make_fixture
cat > "$FIXTURE/valid-skill/SKILL.md" <<'EOF'
---
name: valid-skill
---
Content.
EOF
assert "missing description: in frontmatter fails" 1 bash "$SCRIPT" "$FIXTURE"
rm -rf "$FIXTURE"; FIXTURE=""

# Test: skill slug not in README fails
make_fixture
mkdir -p "$FIXTURE/unlisted-skill"
cat > "$FIXTURE/unlisted-skill/SKILL.md" <<'EOF'
---
name: unlisted-skill
description: A skill missing from the README table
---
Content.
EOF
echo "Greg Weinger <greg@example.com>" > "$FIXTURE/unlisted-skill/AUTHORS"
assert "skill not in README fails" 1 bash "$SCRIPT" "$FIXTURE"
rm -rf "$FIXTURE"; FIXTURE=""

# Test: dist/ directory is not treated as a skill
make_fixture
mkdir -p "$FIXTURE/dist"
assert "dist/ is not treated as a skill" 0 bash "$SCRIPT" "$FIXTURE"
rm -rf "$FIXTURE"; FIXTURE=""

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
