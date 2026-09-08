#!/usr/bin/env bash
# Pull the current machine's ~/.claude skills/agents/commands/hooks back into this repo,
# so changes made locally can be committed and shared.
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${CLAUDE_HOME:-$HOME/.claude}"

for d in skills agents commands hooks; do
  [ -d "$SRC/$d" ] || continue
  rsync -a --delete --exclude .DS_Store --exclude node_modules "$SRC/$d/" "$REPO/$d/"
  echo "synced $d"
done

[ -f "$SRC/plugins/known_marketplaces.json" ] && \
  cp "$SRC/plugins/known_marketplaces.json" "$REPO/plugins/known_marketplaces.json"

echo
echo "Review before committing - settings.json is intentionally NOT synced:"
git -C "$REPO" status --short | head -40
echo
echo "Secret scan:"
if grep -rIlE 'sk-ant-[A-Za-z0-9]{20}|ghp_[A-Za-z0-9]{30}|github_pat_[A-Za-z0-9_]{30}|AKIA[A-Z0-9]{16}|ntn_[A-Za-z0-9]{30}|xox[bap]-[0-9]{8}' "$REPO/skills" "$REPO/agents" "$REPO/commands" "$REPO/hooks" 2>/dev/null; then
  echo "!! secrets found above - remove before committing"
else
  echo "clean"
fi
