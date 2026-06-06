#!/usr/bin/env bash
# Runs all test_*.sh files in tests/. Exits 0 if all pass.
set -uo pipefail
PASS=0; FAIL=0
TESTSDIR="$(dirname "$0")"

shopt -s nullglob
for f in "$TESTSDIR"/test_*.sh; do
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
