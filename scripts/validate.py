#!/usr/bin/env python3
"""Validate the frontmatter of every skill, agent, and command in this repo.

Checks performed:
  skills/<name>/SKILL.md  - file exists, has YAML frontmatter, has `name` and
                            `description`, and `name` matches the directory.
  agents/*.md             - has frontmatter with `name` and `description`.
  commands/*.md           - non-empty; `name` in frontmatter (when present)
                            matches the filename.

Exit code is 1 when any error is found, 0 otherwise.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FRONTMATTER = re.compile(r"\A---\r?\n(.*?)\r?\n---\r?\n", re.DOTALL)

errors: list[str] = []
warnings: list[str] = []


def frontmatter(path: Path) -> dict[str, str] | None:
    """Return top-level scalar keys from a file's YAML frontmatter block."""
    match = FRONTMATTER.match(path.read_text(encoding="utf-8", errors="replace"))
    if not match:
        return None

    fields: dict[str, str] = {}
    key: str | None = None
    for line in match.group(1).splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if line[0] not in " \t" and ":" in line:
            key, _, value = line.partition(":")
            key = key.strip()
            fields[key] = value.strip().strip("'\"").lstrip("|>").strip()
        elif key and line.strip():
            fields[key] = (fields[key] + " " + line.strip()).strip()
    return fields


def check_skills() -> int:
    skills = sorted(p for p in (ROOT / "skills").iterdir() if p.is_dir())
    for skill in skills:
        manifest = skill / "SKILL.md"
        rel = manifest.relative_to(ROOT)

        if not manifest.is_file():
            # A lowercase skill.md loads on case-insensitive macOS and silently
            # fails on Linux, so name the real problem instead of "not found".
            miscased = [p.name for p in skill.iterdir() if p.name.lower() == "skill.md"]
            if miscased:
                errors.append(f"{skill.relative_to(ROOT)}: has {miscased[0]}, must be SKILL.md")
            else:
                errors.append(f"{skill.relative_to(ROOT)}: no SKILL.md")
            continue

        fields = frontmatter(manifest)
        if fields is None:
            errors.append(f"{rel}: missing YAML frontmatter")
            continue

        name = fields.get("name")
        if not name:
            errors.append(f"{rel}: frontmatter has no `name`")
        elif name != skill.name:
            errors.append(f"{rel}: name '{name}' does not match directory '{skill.name}'")

        if not fields.get("description"):
            errors.append(f"{rel}: frontmatter has no `description`")
    return len(skills)


def check_markdown_dir(directory: str, require_description: bool) -> int:
    files = sorted((ROOT / directory).glob("*.md"))
    for path in files:
        rel = path.relative_to(ROOT)
        if not path.read_text(encoding="utf-8", errors="replace").strip():
            errors.append(f"{rel}: file is empty")
            continue

        fields = frontmatter(path)
        if fields is None:
            if require_description:
                errors.append(f"{rel}: missing YAML frontmatter")
            else:
                warnings.append(f"{rel}: no frontmatter block")
            continue

        name = fields.get("name")
        if name and name != path.stem:
            errors.append(f"{rel}: name '{name}' does not match filename '{path.stem}'")
        elif not name and require_description:
            errors.append(f"{rel}: frontmatter has no `name`")

        if require_description and not fields.get("description"):
            errors.append(f"{rel}: frontmatter has no `description`")
    return len(files)


def main() -> int:
    counts = {
        "skills": check_skills(),
        "agents": check_markdown_dir("agents", require_description=True),
        "commands": check_markdown_dir("commands", require_description=False),
    }

    for label, count in counts.items():
        print(f"checked {count:>4} {label}")

    for warning in warnings:
        print(f"warn  {warning}")
    for error in errors:
        print(f"error {error}", file=sys.stderr)

    if errors:
        print(f"\n{len(errors)} error(s)", file=sys.stderr)
        return 1

    print("\nall frontmatter valid")
    return 0


if __name__ == "__main__":
    sys.exit(main())
