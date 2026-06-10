#!/usr/bin/env bash
# Usage: dist.sh [repo_root]
set -uo pipefail
REPO_ROOT="${1:-.}"

bash "$(dirname "$0")/validate.sh" "$REPO_ROOT" || exit 1

mkdir -p "$REPO_ROOT/dist"
count=0

for dir in "$REPO_ROOT"/*/; do
    [ -d "$dir" ] || continue
    [ -f "$dir/SKILL.md" ] || continue
    slug=$(basename "$dir")
    (cd "$REPO_ROOT" && zip -r "dist/$slug.skill" "$slug/" -x "*/.DS_Store" -x "__MACOSX/*" -x "*/._*" -q)
    echo "  ✓ dist/$slug.skill"
    count=$((count + 1))
done

if [ "$count" -eq 0 ]; then
    echo "No skills found to package."
fi
