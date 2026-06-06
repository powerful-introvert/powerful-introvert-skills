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
