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

if [ -f "$SRC/plugins/known_marketplaces.json" ]; then
  cp "$SRC/plugins/known_marketplaces.json" "$REPO/plugins/known_marketplaces.json"
  echo "synced plugins/known_marketplaces.json"
fi

echo
echo "Review before committing - settings.json is intentionally NOT synced:"
git -C "$REPO" status --short | head -40

echo
echo "Secret scan:"
bash "$REPO/scripts/scan-secrets.sh"

echo
echo "Frontmatter:"
python3 "$REPO/scripts/validate.py"
