#!/usr/bin/env bash
# bootstrap.sh — build a personal dev workspace from template/
#
# Usage:  bash bootstrap/bootstrap.sh [target-dir]
# Default target: ~/dev
#
# Safe to re-run: it never overwrites files that already exist.

set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE_DIR="$KIT_DIR/template"
TARGET="${1:-$HOME/dev}"

# Expand a leading ~ if the shell passed it through literally.
TARGET="${TARGET/#\~/$HOME}"

bold()  { printf '\033[1m%s\033[0m\n' "$*"; }
ok()    { printf '  \033[32m✓\033[0m %s\n' "$*"; }
skip()  { printf '  \033[33m•\033[0m %s\n' "$*"; }
fail()  { printf '  \033[31m✗\033[0m %s\n' "$*" >&2; }

bold "Bootstrapping workspace at: $TARGET"
echo

# --- sanity checks -----------------------------------------------------------

if [ ! -d "$TEMPLATE_DIR" ]; then
  fail "template/ not found at $TEMPLATE_DIR — run this from inside the kit repo."
  exit 1
fi

case "$TARGET" in
  *\ *) fail "Path contains a space: $TARGET"
        fail "Spaces break enough build tools that it isn't worth it. Pick another path."
        exit 1 ;;
esac

for cloud in Dropbox "Google Drive" "OneDrive" "Library/Mobile Documents"; do
  case "$TARGET" in
    *"$cloud"*)
      fail "Target is inside a cloud-synced folder ($cloud)."
      fail "Sync daemons corrupt node_modules and .git. Pick a path outside it."
      exit 1 ;;
  esac
done

case "$TARGET" in
  /mnt/c/*|/mnt/d/*)
    fail "Target is on the Windows filesystem ($TARGET)."
    fail "Inside WSL this makes installs 10-50x slower and breaks file watching."
    fail "Use a path under \$HOME instead, e.g. ~/dev"
    exit 1 ;;
esac

# --- copy template -----------------------------------------------------------

mkdir -p "$TARGET"

copied=0
skipped=0
while IFS= read -r -d '' src; do
  rel="${src#"$TEMPLATE_DIR"/}"
  dest="$TARGET/$rel"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ]; then
    skipped=$((skipped + 1))
  else
    cp "$src" "$dest"
    copied=$((copied + 1))
  fi
done < <(find "$TEMPLATE_DIR" -type f -print0)

ok "Copied $copied files"
[ "$skipped" -gt 0 ] && skip "Left $skipped existing files untouched"

# --- project directories -----------------------------------------------------

mkdir -p "$TARGET/projects/apps" "$TARGET/projects/sites" "$TARGET/.claude/skills"
touch "$TARGET/projects/apps/.gitkeep" "$TARGET/projects/sites/.gitkeep"
ok "Created projects/apps and projects/sites"

# --- executable bits ---------------------------------------------------------

chmod +x "$TARGET"/library/tools/*.sh 2>/dev/null || true
ok "Made library/tools scripts executable"

# --- link skills -------------------------------------------------------------

if [ -x "$TARGET/library/tools/link-skills.sh" ]; then
  bash "$TARGET/library/tools/link-skills.sh" "$TARGET"
else
  fail "link-skills.sh missing — skills will not be available to Claude Code."
fi

# --- local env ---------------------------------------------------------------

if [ ! -f "$TARGET/.env" ] && [ -f "$TARGET/.env.example" ]; then
  cp "$TARGET/.env.example" "$TARGET/.env"
  ok "Created .env from .env.example (gitignored — put real secrets here)"
fi

# --- done --------------------------------------------------------------------

echo
bold "Workspace ready."
cat <<SUMMARY

  $TARGET
  ├── CLAUDE.md               instructions Claude reads every session
  ├── PROJECTS.md             index of what you've built
  ├── projects/apps|sites/    your projects go here
  ├── library/                templates, skills, components, guides, tools
  ├── agent-docs/             things you learned worth keeping
  └── .claude/                settings.json + skills symlinks

Next:
  cd $TARGET
  bash library/tools/doctor.sh      # confirm the toolchain is healthy
  code workspace.code-workspace    # open in VS Code
  claude                           # then: /new-project

SUMMARY
