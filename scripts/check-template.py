#!/usr/bin/env python3
"""Verify settings.template.json is valid JSON and still free of real values.

Every `env` value must be a shell-style placeholder, and
`permissions.additionalDirectories` must be empty, so the template stays
machine-agnostic and safe to commit.
"""

from __future__ import annotations

import json
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
TEMPLATE = ROOT / "settings.template.json"


def main() -> int:
    try:
        settings = json.loads(TEMPLATE.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        print(f"settings.template.json is not valid JSON: {exc}", file=sys.stderr)
        return 1

    errors: list[str] = []

    for key, value in (settings.get("env") or {}).items():
        placeholder = isinstance(value, str) and value.startswith("${") and value.endswith("}")
        if not placeholder:
            errors.append(f"env.{key} must be a placeholder such as ${{{key}}}, not a literal value")

    extra_dirs = (settings.get("permissions") or {}).get("additionalDirectories") or []
    if extra_dirs:
        errors.append(f"permissions.additionalDirectories must be empty, found {extra_dirs}")

    for error in errors:
        print(f"error {error}", file=sys.stderr)
    if errors:
        return 1

    print("settings.template.json is valid JSON with placeholders intact")
    return 0


if __name__ == "__main__":
    sys.exit(main())
