#!/usr/bin/env bash
# Usage: validate.sh [repo_root]
set -uo pipefail
REPO_ROOT="${1:-.}"
ERRORS=0

has_frontmatter_key() {
    local file="$1" key="$2"
    awk 'BEGIN{found=0;matched=0} /^---/{found++; next} found==1 && index($0, "'"$key"':") == 1{matched=1} END{exit (matched ? 0 : 1)}' "$file"
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

    if [ ! -f "$REPO_ROOT/README.md" ]; then
        echo "  ✗ $slug: README.md not found (cannot check slug)"
        skill_errors=$((skill_errors + 1))
    elif ! grep -q "\`$slug\`" "$REPO_ROOT/README.md"; then
        echo "  ✗ $slug: not found in README.md skills table"
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
