#!/usr/bin/env python3
"""Compatibility wrapper for the grabchat CLI entry point."""

from pathlib import Path
import runpy
import sys


if __name__ == "__main__":
    root = Path(__file__).resolve().parent.parent
    target = root / ".claude" / "scripts" / "grabchat.py"
    if not target.exists():
        raise SystemExit(f"Missing implementation: {target}")
    sys.path.insert(0, str(target.parent))
    runpy.run_path(str(target), run_name="__main__")
