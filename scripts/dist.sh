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
