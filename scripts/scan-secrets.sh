#!/usr/bin/env bash
# Fail if a credential pattern appears in any tracked file.
# Runs in CI and from sync-from-local.sh before a commit.
# Portable: works on bash 3.2 (stock macOS) as well as bash 5.
set -uo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

LIST="$(mktemp)"
trap 'rm -f "$LIST"' EXIT

if git rev-parse --git-dir >/dev/null 2>&1; then
  git ls-files -z > "$LIST"
else
  find . -type f -not -path './.git/*' -print0 > "$LIST"
fi

COUNT="$(tr -dc '\0' < "$LIST" | wc -c | tr -d ' ')"
if [ "$COUNT" -eq 0 ]; then
  echo "no files to scan"
  exit 0
fi

PATTERNS='sk-ant-[A-Za-z0-9_-]{20,}
ghp_[A-Za-z0-9]{30,}
github_pat_[A-Za-z0-9_]{30,}
gho_[A-Za-z0-9]{30,}
AKIA[A-Z0-9]{16}
ntn_[A-Za-z0-9]{20,}
xox[bapr]-[0-9]{8,}
AIza[A-Za-z0-9_-]{30,}
-----BEGIN [A-Z ]*PRIVATE KEY-----'

HITS="$(mktemp)"
trap 'rm -f "$LIST" "$HITS"' EXIT

while IFS= read -r pattern; do
  [ -n "$pattern" ] || continue
  xargs -0 grep -InIE -e "$pattern" < "$LIST" >> "$HITS" 2>/dev/null || true
done <<< "$PATTERNS"

if [ -s "$HITS" ]; then
  sed 's/^/  /' "$HITS"
  echo
  echo "FAIL: credential pattern found in tracked files (see above)" >&2
  exit 1
fi

echo "scanned $COUNT tracked files - no credential patterns found"
