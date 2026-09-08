#!/usr/bin/env python3
"""Generate docs/SKILLS.md, an alphabetical table of every skill in this repo.

Descriptions come straight from each SKILL.md frontmatter, trimmed to one line,
so the catalog cannot drift from the skills themselves. CI regenerates the file
and fails when the committed copy is stale.

Usage:
    python3 scripts/gen-catalog.py           # write docs/SKILLS.md
    python3 scripts/gen-catalog.py --check   # exit 1 if the file is out of date
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUTPUT = ROOT / "docs" / "SKILLS.md"
FRONTMATTER = re.compile(r"\A---\r?\n(.*?)\r?\n---\r?\n", re.DOTALL)
MAX_CHARS = 140


def description(manifest: Path) -> str:
    """Return the skill's description as a single collapsed line."""
    match = FRONTMATTER.match(manifest.read_text(encoding="utf-8", errors="replace"))
    if not match:
        return ""

    block = match.group(1)
    lines = block.splitlines()
    collected: list[str] = []
    for index, line in enumerate(lines):
        if not re.match(r"^description\s*:", line):
            continue
        head = line.split(":", 1)[1].strip()
        if head not in ("", "|", ">", "|-", ">-", "|+", ">+"):
            collected.append(head)
        for follow in lines[index + 1 :]:
            if follow[:1] not in (" ", "\t"):
                break
            collected.append(follow.strip())
        break

    text = " ".join(collected).strip().strip("'\"")
    text = re.sub(r"\s+", " ", text)
    text = text.replace("|", "\\|")
    if len(text) > MAX_CHARS:
        text = text[: MAX_CHARS - 1].rstrip(" ,.;:") + "…"
    return text


def skill_dirs() -> list[Path]:
    return sorted(
        (p for p in (ROOT / "skills").iterdir() if p.is_dir() and (p / "SKILL.md").is_file()),
        key=lambda p: p.name.lower(),
    )


def render() -> str:
    skills = skill_dirs()

    rows = [f"| [`{s.name}`](../skills/{s.name}/SKILL.md) | {description(s / 'SKILL.md')} |" for s in skills]
    buckets: dict[str, int] = {}
    for skill in skills:
        buckets.setdefault(skill.name[0].upper(), 0)
        buckets[skill.name[0].upper()] += 1
    index = " · ".join(f"**{letter}**&nbsp;{count}" for letter, count in sorted(buckets.items()))

    return "\n".join(
        [
            "# Skill catalog",
            "",
            f"`{len(skills)}` skills, generated from `skills/*/SKILL.md` by "
            "[`scripts/gen-catalog.py`](../scripts/gen-catalog.py). Do not edit by hand.",
            "",
            index,
            "",
            "| Skill | What it does |",
            "| :--- | :--- |",
            *rows,
            "",
        ]
    )


def main() -> int:
    content = render()

    if "--check" in sys.argv:
        current = OUTPUT.read_text(encoding="utf-8") if OUTPUT.is_file() else ""
        if current != content:
            print("docs/SKILLS.md is stale - run `make catalog`", file=sys.stderr)
            return 1
        print("docs/SKILLS.md is up to date")
        return 0

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(content, encoding="utf-8")
    print(f"wrote {OUTPUT.relative_to(ROOT)} ({len(skill_dirs())} skills)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
