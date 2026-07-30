#!/usr/bin/env sh
set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

VENV_DIR="$ROOT_DIR/.venv"
VENV_PYTHON="$VENV_DIR/bin/python"

if [ ! -x "$VENV_PYTHON" ]; then
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

if [ ! -x "$VENV_PYTHON" ]; then
  echo "Virtual environment Python not found at $VENV_PYTHON" >&2
  exit 1
fi

"$VENV_PYTHON" -m pip install --upgrade pip pytest >/dev/null 2>&1 || true
exec "$VENV_PYTHON" -c 'import pytest, sys; raise SystemExit(pytest.main(["-q"] + sys.argv[1:]))' "$@"
