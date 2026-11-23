#!/usr/bin/env bash
# myskills installer — Linux/macOS/Git-Bash
# Every folder holding a SKILL.md is a skill. The folder name is the command name.
#   Claude Code -> ~/.claude/skills/<name>/    (whole folder)
#   Codex       -> ~/.codex/skills/<name>/     (whole folder)
#   Cursor      -> ~/.cursor/commands/<name>.md (flattened: Cursor has commands, not skills)
# Options: --with-agents   also copy agents/*.md to ~/.claude/agents
#          --with-settings print the settings snippet to merge by hand (never overwrites anything)
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WITH_AGENTS=0; WITH_SETTINGS=0
for a in "$@"; do
  case "$a" in
    --with-agents) WITH_AGENTS=1 ;;
    --with-settings) WITH_SETTINGS=1 ;;
    *) echo "unknown option: $a" >&2; exit 2 ;;
  esac
done

CLAUDE_SKILLS="$HOME/.claude/skills"; CLAUDE_CMDS="$HOME/.claude/commands"
CODEX_SKILLS="$HOME/.codex/skills";   CODEX_PROMPTS="$HOME/.codex/prompts"
CURSOR_CMDS="$HOME/.cursor/commands"

# every SKILL.md outside hidden folders
mapfile -d '' FILES < <(find "$SRC" -type f -name SKILL.md -not -path '*/.*' -print0 | sort -z)

install_skills() {
  local dir="$1" label="$2" n=0
  mkdir -p "$dir"
  for f in "${FILES[@]}"; do
    local folder name; folder="$(dirname "$f")"; name="$(basename "$folder")"
    rm -rf "${dir:?}/$name"
    cp -R "$folder" "$dir/$name"
    n=$((n+1))
  done
  echo "  [$label] $n skills -> $dir"
}

install_cursor() {
  local n=0
  mkdir -p "$CURSOR_CMDS"
  for f in "${FILES[@]}"; do
    cp -f "$f" "$CURSOR_CMDS/$(basename "$(dirname "$f")").md"
    n=$((n+1))
  done
  echo "  [Cursor] $n commands -> $CURSOR_CMDS"
}

# older versions installed flat .md commands; remove those copies so a skill is not listed twice
remove_legacy() {
  for f in "${FILES[@]}"; do
    local name; name="$(basename "$(dirname "$f")")"
    rm -f "$CLAUDE_CMDS/$name.md" "$CODEX_PROMPTS/$name.md"
  done
}

echo "myskills installer"
install_skills "$CLAUDE_SKILLS" "Claude Code"
install_skills "$CODEX_SKILLS" "Codex"
install_cursor
remove_legacy

if [ "$WITH_AGENTS" = 1 ]; then
  mkdir -p "$HOME/.claude/agents"
  cp -f "$SRC"/agents/*.md "$HOME/.claude/agents/"
  echo "  [Agents] $(ls "$SRC"/agents/*.md | wc -l | tr -d ' ') agents -> $HOME/.claude/agents"
fi

if [ "$WITH_SETTINGS" = 1 ]; then
  echo
  echo "Merge this into ~/.claude/settings.json by hand (nothing was changed):"
  cat "$SRC/setup/settings.snippet.json"
  echo
  echo "Routing rules for your CLAUDE.md: $SRC/setup/CLAUDE.model-routing.md"
fi
echo "Done."
