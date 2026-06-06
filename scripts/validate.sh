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
