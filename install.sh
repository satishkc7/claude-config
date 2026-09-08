#!/usr/bin/env bash
# Install this repo's Claude Code skills/agents/commands/hooks into ~/.claude
# Usage:
#   ./install.sh            # copy (default)
#   ./install.sh --link     # symlink dirs to this repo (edits here apply everywhere)
#   ./install.sh --dry-run  # show what would change
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${CLAUDE_HOME:-$HOME/.claude}"
MODE="copy"
DRY=0
for a in "$@"; do
  case "$a" in
    --link) MODE="link" ;;
    --dry-run) DRY=1 ;;
    *) echo "unknown flag: $a" >&2; exit 2 ;;
  esac
done

DIRS=(skills agents commands hooks)
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$DEST/backups/config-import-$STAMP"

# Echo instead of executing when --dry-run is set.
run() {
  if [ "$DRY" = 1 ]; then
    echo "DRY: $*"
  else
    "$@"
  fi
}

mkdir -p "$DEST"

for d in "${DIRS[@]}"; do
  src="$REPO/$d"
  dst="$DEST/$d"
  [ -d "$src" ] || continue

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    run mkdir -p "$BACKUP"
    [ "$DRY" = 1 ] && echo "DRY: cp -R $dst $BACKUP/$d"
    cp -R "$dst" "$BACKUP/$d" 2>/dev/null || true
  fi

  if [ "$MODE" = "link" ]; then
    run rm -rf "$dst"
    run ln -s "$src" "$dst"
    [ "$DRY" = 1 ] || echo "linked  $dst -> $src"
  else
    run mkdir -p "$dst"
    run rsync -a --exclude .DS_Store "$src/" "$dst/"
    [ "$DRY" = 1 ] || echo "copied  $src/ -> $dst/"
  fi
done

# hooks need executable bits
if [ "$DRY" = 0 ] && [ -d "$DEST/hooks" ]; then
  chmod +x "$DEST/hooks"/*.sh 2>/dev/null || true
fi

# plugin marketplaces (additive, never overwrite)
if [ -f "$REPO/plugins/known_marketplaces.json" ] && [ ! -f "$DEST/plugins/known_marketplaces.json" ]; then
  run mkdir -p "$DEST/plugins"
  run cp "$REPO/plugins/known_marketplaces.json" "$DEST/plugins/known_marketplaces.json"
  echo "installed plugin marketplace list"
fi

# settings: never clobber an existing one
if [ ! -f "$DEST/settings.json" ]; then
  run cp "$REPO/settings.template.json" "$DEST/settings.json"
  echo "wrote   $DEST/settings.json from template (fill in env vars)"
else
  echo "kept    existing $DEST/settings.json  (merge from $REPO/settings.template.json by hand)"
fi

echo
if [ -d "$BACKUP" ]; then
  echo "backup of replaced dirs: $BACKUP"
fi
echo "done. restart Claude Code, then run /skills to verify."
