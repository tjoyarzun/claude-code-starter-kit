#!/usr/bin/env bash
# link-skills.sh — symlink every pantry skill into .claude/skills/ so Claude Code finds them.
#
# Usage: bash link-skills.sh [workspace-dir]
# Default workspace: the parent of pantry/ (i.e. two levels up from this script).
#
# Symlinks, not copies: editing pantry/skills/<name>/SKILL.md takes effect immediately,
# with no sync step to forget.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WS="${1:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
WS="${WS/#\~/$HOME}"

SKILLS_SRC="$WS/pantry/skills"
SKILLS_DST="$WS/.claude/skills"

ok()   { printf '  \033[32m✓\033[0m %s\n' "$*"; }
bad()  { printf '  \033[31m✗\033[0m %s\n' "$*" >&2; }

if [ ! -d "$SKILLS_SRC" ]; then
  bad "No pantry/skills directory at $SKILLS_SRC"
  exit 1
fi

mkdir -p "$SKILLS_DST"

linked=0
for dir in "$SKILLS_SRC"/*/; do
  [ -d "$dir" ] || continue
  name="$(basename "$dir")"
  if [ ! -f "$dir/SKILL.md" ]; then
    bad "$name has no SKILL.md — skipping"
    continue
  fi
  ln -sfn "$dir" "$SKILLS_DST/$name"
  linked=$((linked + 1))
done

ok "Linked $linked skill(s) into .claude/skills/"

if [ "$linked" -gt 0 ]; then
  printf '      \033[2m%s\033[0m\n' "$(cd "$SKILLS_DST" && ls -1 | tr '\n' ' ')"
  printf '      \033[2mRestart any running Claude Code session to pick them up.\033[0m\n'
fi
