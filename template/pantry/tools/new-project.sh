#!/usr/bin/env bash
# new-project.sh — copy a scaffold into projects/ and initialize git.
#
# Usage: bash new-project.sh <app|site> <slug>
# Example: bash new-project.sh app budget-tracker
#
# This is the non-interactive core. The /new-project skill wraps it with an interview,
# GitHub repo creation, and a first commit — prefer the skill unless you're scripting.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WS="$(cd "$SCRIPT_DIR/../.." && pwd)"

SHAPE="${1:-}"
SLUG="${2:-}"

usage() {
  cat <<USAGE
Usage: bash new-project.sh <app|site> <slug>

  app   Vite + React + TypeScript + Tailwind   → projects/apps/<slug>/
  site  Plain HTML/CSS/JS                      → projects/sites/<slug>/

Slug rules: lowercase letters, numbers, and hyphens only.
USAGE
}

if [ -z "$SHAPE" ] || [ -z "$SLUG" ]; then usage; exit 2; fi

case "$SHAPE" in
  app)  SRC="$WS/pantry/scaffold/web-app";     DEST="$WS/projects/apps/$SLUG" ;;
  site) SRC="$WS/pantry/scaffold/static-site"; DEST="$WS/projects/sites/$SLUG" ;;
  *)    usage; exit 2 ;;
esac

if ! printf '%s' "$SLUG" | grep -Eq '^[a-z0-9][a-z0-9-]*$'; then
  echo "✗ Invalid slug: '$SLUG' — use lowercase letters, numbers, and hyphens." >&2
  exit 2
fi

if [ -e "$DEST" ]; then
  echo "✗ $DEST already exists. Pick another name." >&2
  exit 1
fi

if [ ! -d "$SRC" ]; then
  echo "✗ Scaffold not found at $SRC" >&2
  exit 1
fi

mkdir -p "$(dirname "$DEST")"
cp -R "$SRC" "$DEST"

# Name the project after the slug rather than the scaffold.
if [ -f "$DEST/package.json" ]; then
  sed -i.bak "s/\"name\": \"personal-web-app\"/\"name\": \"$SLUG\"/" "$DEST/package.json"
  [ -f "$DEST/package.json.bak" ] && command rm -f "$DEST/package.json.bak"
fi

git -C "$DEST" init -q
git -C "$DEST" add -A

printf '\033[32m✓\033[0m Created %s\n\n' "$DEST"
cat <<NEXT
Next:
  cd $DEST
NEXT
if [ "$SHAPE" = "app" ]; then
  cat <<NEXT
  pnpm install
  pnpm dev                       # http://localhost:5173
NEXT
else
  cat <<NEXT
  npx serve .                    # or just open index.html
NEXT
fi
cat <<NEXT
  git commit -m "initial commit"
  gh repo create $SLUG --private --source=. --push

Then add a row for it in pantry/solutions/README.md.
NEXT
