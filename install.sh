#!/usr/bin/env bash
# myskills installer — Linux/macOS/Git-Bash
# Installs ALL prompt .md files as slash commands for Claude Code, Cursor, Codex.
# New .md files are picked up automatically — no per-file list to maintain.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CLAUDE_DIR="$HOME/.claude/commands"
CURSOR_DIR="$HOME/.cursor/commands"
CODEX_DIR="$HOME/.codex/prompts"

# dest name from path: frontend/angular/* -> ng-*, frontend/hybris/* -> hybris-*, else basename
dest_name() {
  local rel="$1" base; base="$(basename "$rel")"
  case "$rel" in
    frontend/angular/*) echo "ng-$base" ;;
    frontend/hybris/*)  echo "hybris-$base" ;;
    *)                  echo "$base" ;;
  esac
}

install_to() {
  local dir="$1" label="$2"
  mkdir -p "$dir"
  local n=0
  while IFS= read -r -d '' f; do
    local rel="${f#$SRC/}"
    cp -f "$f" "$dir/$(dest_name "$rel")"
    n=$((n+1))
  done < <(find "$SRC/frontend" "$SRC/general" -type f -name '*.md' -print0 2>/dev/null)
  echo "  [$label] $n files -> $dir"
}

echo "myskills installer"
install_to "$CLAUDE_DIR" "Claude Code"
install_to "$CURSOR_DIR" "Cursor"
install_to "$CODEX_DIR"  "Codex"
echo "Done."
