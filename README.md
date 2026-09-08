<h1 align="center">claude-config</h1>

<p align="center">
  <em>Portable Claude Code environment. One clone, one command, same setup on every machine.</em>
</p>

<p align="center">
  <a href="https://github.com/satishkc7/claude-config/actions/workflows/ci.yml"><img alt="ci" src="https://github.com/satishkc7/claude-config/actions/workflows/ci.yml/badge.svg"></a>
  <img alt="skills" src="https://img.shields.io/badge/skills-135-1f6feb">
  <img alt="agents" src="https://img.shields.io/badge/subagents-7-1f6feb">
  <img alt="commands" src="https://img.shields.io/badge/commands-9-1f6feb">
  <img alt="hooks" src="https://img.shields.io/badge/hooks-8-1f6feb">
  <a href="LICENSE"><img alt="license" src="https://img.shields.io/badge/license-MIT-3fb950"></a>
  <img alt="platform" src="https://img.shields.io/badge/platform-macOS%20%7C%20Linux-8b949e">
</p>

---

`~/.claude` accumulates real engineering work: skills you wrote, subagents you tuned, slash commands
that encode your workflow, hooks that shape every session. None of it is version controlled, and
none of it follows you to a new laptop or a second account.

This repo is that config, extracted, validated in CI, and installable in one command.

```console
$ git clone https://github.com/satishkc7/claude-config.git ~/claude-config
$ cd ~/claude-config && make install
copied  skills/    -> ~/.claude/skills/
copied  agents/    -> ~/.claude/agents/
copied  commands/  -> ~/.claude/commands/
copied  hooks/     -> ~/.claude/hooks/
wrote   ~/.claude/settings.json from template (fill in env vars)
done. restart Claude Code, then run /skills to verify.
```

## Layout

```
claude-config/
├── skills/                      135 Agent Skills, one directory per skill
│   └── <name>/SKILL.md          YAML frontmatter (name + description) + instructions
├── agents/                      7 subagent definitions for the Agent tool
├── commands/                    9 slash commands (/build /plan /review /ship /spec /test ...)
├── hooks/                       SessionStart, UserPromptSubmit, Stop, and statusline scripts
├── plugins/
│   └── known_marketplaces.json  marketplaces to re-add with /plugin
├── scripts/
│   ├── validate.py              frontmatter linter (names, descriptions, dir/name match)
│   ├── scan-secrets.sh          credential scanner over tracked files
│   └── check-template.py        asserts the settings template stays placeholder-only
├── settings.template.json       user settings, secrets and machine paths stripped
├── install.sh                   repo  -> ~/.claude
├── sync-from-local.sh           ~/.claude -> repo
└── Makefile                     install | link | sync | check | lint | template | secrets | stats
```

## Install

```bash
make install     # copy into ~/.claude          (default, safest)
make link        # symlink ~/.claude dirs here  (edits apply immediately)
make check       # lint + secret scan, no writes
./install.sh --dry-run
```

Target directory is `$CLAUDE_HOME`, defaulting to `~/.claude`.

| | copy | link |
| --- | --- | --- |
| repo and live config | independent | same files |
| edit a skill, see it live | after `make install` | immediately |
| `git status` reflects reality | after `make sync` | always |
| Claude writing into the dir | stays local | lands in the repo |

Anything replaced is backed up to `~/.claude/backups/config-import-<timestamp>/` first. An existing
`settings.json` is never overwritten.

Restart Claude Code, then confirm with `/skills`, `/agents`, and `/hooks`.

## Settings

`settings.template.json` carries the hook wiring, statusline, model, and effort level. Two fields are
blanked on purpose, and CI fails if either is ever filled in:

| Field | Why it is blank | What to do |
| --- | --- | --- |
| `env.NOTION_API_KEY` | real key, must not be committed | export it in your shell, or set it in `~/.claude/settings.json` |
| `permissions.additionalDirectories` | machine-specific paths | add your own project paths locally |

Two hook entries call `~/.claude-mem/capture.sh` and `~/.claude-mem/summarize.sh`. Install
[claude-mem](https://github.com/thedotmack/claude-mem) or drop those entries from `settings.json`.

## Excluded by design

`.gitignore` blocks the parts of `~/.claude` that are either secret or worthless on another machine:

- `settings.local.json` - permission rules with live access tokens embedded in them
- `projects/` - per-project state, including the auto-memory files and their credentials
- `history.jsonl`, `sessions/`, `session-env/`, `shell-snapshots/` - session state
- `telemetry/`, `paste-cache/`, `file-history/`, `cache/`, `backups/` - transient data

Sync auto-memory through a separate **private** repo if you want it on more than one machine.

## Updating

```bash
make sync                                  # ~/.claude -> repo, then lint + secret scan
git add -A && git commit -m "..." && git push
```

On every other machine: `git pull && make install`. Nothing to do if you installed with `make link`.

## CI

`.github/workflows/ci.yml` runs on push and pull request:

1. `scripts/validate.py` - every skill has a `SKILL.md` whose frontmatter `name` matches its
   directory and carries a description; same check for agents and commands
2. `scripts/scan-secrets.sh` - 9 credential patterns across all tracked files
3. `shellcheck -S warning` on the installer, the sync script, and the scanner; vendored
   `hooks/*.sh` are checked too, but advisory only
4. `scripts/check-template.py` - `settings.template.json` parses and still has its placeholders
5. the installer runs against a throwaway `CLAUDE_HOME` and the result is asserted

## Requirements

`bash` 3.2+, `git`, `rsync`, `python3` 3.9+. No other dependencies.

## License

MIT. See [LICENSE](LICENSE). Third-party skills keep whatever license their author assigned.
