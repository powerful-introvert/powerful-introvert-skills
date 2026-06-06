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

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
