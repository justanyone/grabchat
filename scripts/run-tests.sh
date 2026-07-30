#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VENV_DIR="$REPO_ROOT/.venv"
VENV_PYTHON="$VENV_DIR/bin/python"

if [[ ! -x "$VENV_PYTHON" ]]; then
  if command -v python3 >/dev/null 2>&1; then
    PYTHON_BIN=python3
  elif command -v python >/dev/null 2>&1; then
    PYTHON_BIN=python
  else
    echo "Python interpreter not found" >&2
    exit 1
  fi

  "$PYTHON_BIN" -m venv "$VENV_DIR"
fi

if [[ ! -x "$VENV_PYTHON" ]]; then
  echo "Virtual environment Python not found at $VENV_PYTHON" >&2
  exit 1
fi

"$VENV_PYTHON" -m pip install --upgrade pip pytest >/dev/null 2>&1 || true
exec "$VENV_PYTHON" -c 'import pytest, sys; raise SystemExit(pytest.main(["-q"] + sys.argv[1:]))' "$@"
