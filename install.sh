#!/usr/bin/env bash
# myskills installer — Linux/macOS/Git-Bash
# Installs prompt files as slash commands for Claude Code, Cursor, Codex.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# target dirs per tool
CLAUDE_DIR="$HOME/.claude/commands"
CURSOR_DIR="$HOME/.cursor/commands"
CODEX_DIR="$HOME/.codex/prompts"

# src -> dest name (renamed to avoid collisions)
declare -a MAP=(
  "frontend/angular/safetoship.md|ng-safetoship.md"
  "frontend/angular/safetoshiplite.md|ng-safetoshiplite.md"
  "frontend/hybris/safetoship.md|hybris-safetoship.md"
  "frontend/hybris/safetoshiplite.md|hybris-safetoshiplite.md"
  "general/befable/befablefull.md|befablefull.md"
  "general/befable/befablelite.md|befablelite.md"
  "general/befable/befableplan.md|befableplan.md"
  "general/befable/befablerun.md|befablerun.md"
)

install_to() {
  local dir="$1" label="$2"
  mkdir -p "$dir"
  local n=0
  for pair in "${MAP[@]}"; do
    local src="${pair%%|*}" dst="${pair##*|}"
    if [[ -f "$SRC/$src" ]]; then
      cp -f "$SRC/$src" "$dir/$dst"
      n=$((n+1))
    else
      echo "  ! missing: $src"
    fi
  done
  echo "  [$label] $n files -> $dir"
}

echo "myskills installer"
install_to "$CLAUDE_DIR" "Claude Code"
install_to "$CURSOR_DIR" "Cursor"
install_to "$CODEX_DIR"  "Codex"
echo "Done. Use: /ng-safetoship /hybris-safetoship /befablefull etc."
