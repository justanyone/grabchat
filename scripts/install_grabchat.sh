#!/usr/bin/env bash
set -euo pipefail

if [[ $# -gt 1 ]]; then
  echo "Usage: $0 [target-directory]" >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="${1:-$(pwd)}"
if [[ ! -d "$TARGET_DIR" ]]; then
  mkdir -p "$TARGET_DIR"
fi
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

copy_if_missing() {
  local src="$1"
  local dest="$2"
  if [[ -e "$dest" ]]; then
    echo "Preserving existing file: $dest"
  else
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo "Installed: $dest"
  fi
}

copy_tree_if_missing() {
  local src_dir="$1"
  local dest_dir="$2"
  if [[ -d "$src_dir" ]]; then
    while IFS= read -r -d '' src_path; do
      rel_path="${src_path#$src_dir/}"
      dest_path="$dest_dir/$rel_path"
      if [[ -e "$dest_path" ]]; then
        echo "Preserving existing file: $dest_path"
      else
        mkdir -p "$(dirname "$dest_path")"
        cp "$src_path" "$dest_path"
        echo "Installed: $dest_path"
      fi
    done < <(find "$src_dir" -type f -print0)
  fi
}

mkdir -p "$TARGET_DIR/.claude"
mkdir -p "$TARGET_DIR/.github"
mkdir -p "$TARGET_DIR/.chat_history"

if [[ ! -f "$TARGET_DIR/.chat_history/.gitignore" ]]; then
  cat > "$TARGET_DIR/.chat_history/.gitignore" <<'EOF'
*
!.gitignore
EOF
  echo "Installed: $TARGET_DIR/.chat_history/.gitignore"
else
  echo "Preserving existing file: $TARGET_DIR/.chat_history/.gitignore"
fi

copy_if_missing "$ROOT_DIR/.claude/scripts/grabchat.py" "$TARGET_DIR/.claude/scripts/grabchat.py"
copy_if_missing "$ROOT_DIR/.claude/scripts/grabchat.ini" "$TARGET_DIR/.claude/scripts/grabchat.ini"
copy_tree_if_missing "$ROOT_DIR/.claude/skills" "$TARGET_DIR/.claude/skills"
copy_tree_if_missing "$ROOT_DIR/.claude/commands" "$TARGET_DIR/.claude/commands"

if [[ -d "$TARGET_DIR/.claude" ]]; then
  copy_if_missing "$ROOT_DIR/.claude/commands/grabchat.md" "$TARGET_DIR/.claude/commands/grabchat.md"
  copy_if_missing "$ROOT_DIR/.claude/commands/grabchat/README.md" "$TARGET_DIR/.claude/commands/grabchat/README.md"
fi

if [[ -d "$TARGET_DIR/.github" ]]; then
  if [[ -f "$TARGET_DIR/.github/copilot-instructions.md" ]]; then
    mkdir -p "$TARGET_DIR/.github/prompts"
    copy_if_missing "$ROOT_DIR/.github/prompts/grabchat.prompt.md" "$TARGET_DIR/.github/prompts/grabchat.prompt.md"
    copy_if_missing "$ROOT_DIR/.github/instructions/grabchat.instructions.md" "$TARGET_DIR/.github/instructions/grabchat.instructions.md"
  else
    mkdir -p "$TARGET_DIR/.github"
    copy_if_missing "$ROOT_DIR/.github/prompts/grabchat.prompt.md" "$TARGET_DIR/.github/prompts/grabchat.prompt.md"
    copy_if_missing "$ROOT_DIR/.github/instructions/grabchat.instructions.md" "$TARGET_DIR/.github/instructions/grabchat.instructions.md"
  fi
fi

if [[ -d "$TARGET_DIR/.claude" && -f "$TARGET_DIR/.claude/commands/grabchat.md" ]]; then
  mkdir -p "$TARGET_DIR/.claude/commands/grabchat"
  copy_if_missing "$ROOT_DIR/.claude/commands/grabchat/README.md" "$TARGET_DIR/.claude/commands/grabchat/README.md"
fi

if [[ -f "$TARGET_DIR/.claude/CLAUDE.md" ]]; then
  if ! grep -q '/grabchat' "$TARGET_DIR/.claude/CLAUDE.md"; then
    printf '\n# grabchat\nUse /grabchat to export the current Claude Code session transcript to Markdown.\n' >> "$TARGET_DIR/.claude/CLAUDE.md"
  fi
fi

if [[ -d "$TARGET_DIR/.github" && -f "$TARGET_DIR/.github/copilot-instructions.md" ]]; then
  if ! grep -q 'grabchat' "$TARGET_DIR/.github/copilot-instructions.md"; then
    printf '\n## grabchat\nUse the /grabchat slash command to export the current session transcript to Markdown.\n' >> "$TARGET_DIR/.github/copilot-instructions.md"
  fi
fi

echo "Install complete."
