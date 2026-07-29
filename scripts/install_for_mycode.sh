#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_ROOT="${1:-$HOME/mycode}"

if [[ ! -d "$TARGET_ROOT" ]]; then
  echo "Creating target root: $TARGET_ROOT"
  mkdir -p "$TARGET_ROOT"
fi

if [[ ! -d "$TARGET_ROOT/someproject" ]]; then
  echo "Creating target project: $TARGET_ROOT/someproject"
  mkdir -p "$TARGET_ROOT/someproject"
fi

bash "$ROOT_DIR/scripts/install_grabchat.sh" "$TARGET_ROOT/someproject"
