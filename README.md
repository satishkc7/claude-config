# claude-config

Portable Claude Code configuration: skills, subagents, slash commands, hooks, and a sanitized
`settings.json` template. Clone this on any machine or under any Claude account to get the same
setup.

## Contents

| Path | What it is |
| --- | --- |
| `skills/` | Agent Skills (one directory per skill, each with a `SKILL.md`) |
| `agents/` | Custom subagent definitions used by the Agent tool |
| `commands/` | Slash commands (`/build`, `/plan`, `/review`, `/ship`, `/spec`, `/test`, ...) |
| `hooks/` | Hook scripts referenced from `settings.json` (caveman mode, statusline, model overrides) |
| `plugins/known_marketplaces.json` | Plugin marketplaces to re-add with `/plugin` |
| `settings.template.json` | User settings with secrets and machine paths stripped out |
| `install.sh` | Installs everything into `~/.claude` |
| `sync-from-local.sh` | Copies the current machine's `~/.claude` back into this repo |

## Install on a new machine

```bash
git clone https://github.com/<user>/claude-config.git ~/claude-config
cd ~/claude-config
./install.sh            # copy into ~/.claude
# or
./install.sh --link     # symlink skills/agents/commands/hooks to this repo
./install.sh --dry-run  # preview only
```

Existing directories are backed up to `~/.claude/backups/config-import-<timestamp>/` before being
replaced. An existing `~/.claude/settings.json` is never overwritten; merge from
`settings.template.json` by hand.

Restart Claude Code afterwards, then run `/skills` to confirm the skills are loaded.

### Copy vs. link

- **copy** (default) is safest: the repo and the live config are independent, and
  `sync-from-local.sh` moves changes back when you want them shared.
- **link** replaces the four directories with symlinks into the repo, so editing a skill here takes
  effect immediately everywhere and `git status` always reflects reality. Note that Claude Code
  writing into a linked directory writes into the repo.

## Settings

`settings.template.json` keeps the hook wiring, statusline, model, and effort level, but two things
are deliberately blanked:

- `env.NOTION_API_KEY` is a `${NOTION_API_KEY}` placeholder. Put the real value in your shell
  environment, or paste it into `~/.claude/settings.json` locally (never back into this repo).
- `permissions.additionalDirectories` is empty. Add machine-specific project paths locally.

Some hook commands reference `~/.claude-mem/`. Install
[claude-mem](https://github.com/thedotmack/claude-mem) or delete those hook entries if you do not
use it.

## What is intentionally not in this repo

`settings.local.json` (contains real access tokens inside permission rules), `projects/` (per-project
state and the auto-memory files), `history.jsonl`, session data, telemetry, caches, and backups. All
of these are covered by `.gitignore`.

Auto-memory lives in `~/.claude/projects/<slug>/memory/` and holds personal notes and credentials, so
it stays out of a shareable repo. If you want it synced too, use a separate private repository.

## Updating

```bash
cd ~/claude-config
./sync-from-local.sh    # bring local skill edits back into the repo, runs a secret scan
git add -A && git commit -m "update skills" && git push
```

On the other machines: `git pull && ./install.sh` (or nothing at all, if you installed with `--link`).
