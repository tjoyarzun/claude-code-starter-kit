#!/usr/bin/env bash
# doctor.sh — check the toolchain and print exactly how to fix what's missing.
# Usage: bash doctor.sh
# Exit 0 = everything required is present. Exit 1 = something required is missing.

set -uo pipefail

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
ok()   { printf '  \033[32m✓\033[0m %-12s %s\n' "$1" "${2:-}"; }
warn() { printf '  \033[33m•\033[0m %-12s %s\n' "$1" "${2:-}"; }
bad()  { printf '  \033[31m✗\033[0m %-12s %s\n' "$1" "${2:-}"; }
hint() { printf '      \033[2m↳ %s\033[0m\n' "$*"; }

MISSING=0

# --- platform ---------------------------------------------------------------

OS="unknown"
case "$(uname -s)" in
  Darwin) OS="macos" ;;
  Linux)
    if grep -qi microsoft /proc/version 2>/dev/null; then OS="wsl"; else OS="linux"; fi ;;
esac

bold "Platform"
case "$OS" in
  macos) ok "macOS" "$(sw_vers -productVersion 2>/dev/null || echo '')  arch: $(uname -m)" ;;
  wsl)   ok "WSL2" "$(. /etc/os-release 2>/dev/null && echo "$PRETTY_NAME")"
         case "$PWD" in
           /mnt/*) bad "filesystem" "you are on the Windows filesystem ($PWD)"
                   hint "Move projects under \$HOME — /mnt/c is 10-50x slower and breaks file watching"
                   MISSING=$((MISSING+1)) ;;
           *) ok "filesystem" "Linux side — correct" ;;
         esac ;;
  linux) ok "Linux" "$(. /etc/os-release 2>/dev/null && echo "$PRETTY_NAME")" ;;
  *)     warn "unknown OS" "$(uname -s)" ;;
esac
echo

# --- required tools ---------------------------------------------------------

check() {                       # check <cmd> <version-flag> <install-hint-macos> <install-hint-linux>
  local cmd="$1" flag="$2" mac="$3" lin="$4" ver
  if command -v "$cmd" >/dev/null 2>&1; then
    ver="$($cmd $flag 2>&1 | head -n1)"
    ok "$cmd" "$ver"
    return 0
  fi
  bad "$cmd" "not installed"
  if [ "$OS" = "macos" ]; then hint "$mac"; else hint "$lin"; fi
  MISSING=$((MISSING+1))
  return 1
}

bold "Required"
check git  --version "brew install git" "sudo apt install -y git"
check node --version "brew install node" "nvm install --lts    # do NOT use apt for node"
check pnpm --version "corepack enable && corepack prepare pnpm@latest --activate" \
                     "corepack enable && corepack prepare pnpm@latest --activate"
check gh   --version "brew install gh" "see https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
echo

# --- node version floor -----------------------------------------------------

if command -v node >/dev/null 2>&1; then
  NODE_MAJOR="$(node -v | sed 's/^v//' | cut -d. -f1)"
  if [ "$NODE_MAJOR" -lt 20 ] 2>/dev/null; then
    bad "node version" "v$NODE_MAJOR is too old — Vite 6 needs 20+"
    if [ "$OS" = "macos" ]; then hint "brew upgrade node"; else hint "nvm install --lts && nvm use --lts"; fi
    MISSING=$((MISSING+1))
  fi
fi

# --- editors and optional tools ---------------------------------------------

bold "Editor and optional"
if command -v code >/dev/null 2>&1; then
  ok "code" "$(code --version 2>/dev/null | head -n1)"
else
  bad "code" "VS Code shell command not installed"
  if [ "$OS" = "macos" ]; then
    hint "In VS Code: Cmd+Shift+P → \"Shell Command: Install 'code' command in PATH\""
  else
    hint "Install VS Code on Windows + the WSL extension, then 'code .' works from here"
  fi
  MISSING=$((MISSING+1))
fi

if command -v claude >/dev/null 2>&1; then
  ok "claude" "$(claude --version 2>/dev/null | head -n1)"
else
  bad "claude" "not installed"
  hint "curl -fsSL https://claude.ai/install.sh | bash"
  MISSING=$((MISSING+1))
fi

if command -v vercel >/dev/null 2>&1; then
  ok "vercel" "$(vercel --version 2>/dev/null | head -n1)"
else
  warn "vercel" "not installed (optional until your first deploy)"
  hint "pnpm add -g vercel"
fi
echo

# --- auth state -------------------------------------------------------------

bold "Accounts"
if command -v git >/dev/null 2>&1; then
  GIT_NAME="$(git config --global user.name  || true)"
  GIT_MAIL="$(git config --global user.email || true)"
  if [ -n "$GIT_NAME" ] && [ -n "$GIT_MAIL" ]; then
    ok "git identity" "$GIT_NAME <$GIT_MAIL>"
  else
    bad "git identity" "not configured — commits will fail"
    hint "git config --global user.name \"Your Name\""
    hint "git config --global user.email \"you@example.com\""
    MISSING=$((MISSING+1))
  fi
fi

if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then
    ok "github" "$(gh api user --jq .login 2>/dev/null || echo 'authenticated')"
  else
    bad "github" "not logged in"
    hint "gh auth login    # choose GitHub.com → HTTPS → browser"
    MISSING=$((MISSING+1))
  fi
fi

if command -v vercel >/dev/null 2>&1; then
  if vercel whoami >/dev/null 2>&1; then
    ok "vercel" "$(vercel whoami 2>/dev/null | tail -n1)"
  else
    warn "vercel" "not logged in"
    hint "vercel login"
  fi
fi
echo

# --- workspace state --------------------------------------------------------

WS=""
for candidate in "$PWD" "$(dirname "$PWD")" "$HOME/dev" "$HOME/code" "$HOME/projects"; do
  if [ -f "$candidate/CLAUDE.md" ] && [ -d "$candidate/library" ]; then WS="$candidate"; break; fi
done

if [ -n "$WS" ]; then
  bold "Workspace: $WS"
  [ -f "$WS/CLAUDE.md" ]              && ok "CLAUDE.md"  "present"
  [ -f "$WS/.claude/settings.json" ]  && ok "settings"   "permission allowlist present" \
                                      || { warn "settings" "no .claude/settings.json"; }
  SKILLS="$(find "$WS/.claude/skills" -maxdepth 1 -mindepth 1 2>/dev/null | wc -l | tr -d ' ')"
  if [ "${SKILLS:-0}" -gt 0 ]; then
    ok "skills" "$SKILLS linked"
  else
    bad "skills" "none linked"
    hint "bash $WS/library/tools/link-skills.sh"
    MISSING=$((MISSING+1))
  fi
  if [ -f "$WS/.env" ] && [ -d "$WS/.git" ]; then
    git -C "$WS" check-ignore -q .env 2>/dev/null \
      && ok ".env" "gitignored — good" \
      || { bad ".env" "NOT gitignored — you will leak secrets"; MISSING=$((MISSING+1)); }
  fi
  echo
fi

# --- verdict ----------------------------------------------------------------

if [ "$MISSING" -eq 0 ]; then
  bold "All good. Nothing blocking."
  exit 0
fi
bold "$MISSING item(s) need attention — see the ↳ hints above."
printf '\033[2mStuck? Run `claude` and paste this output.\033[0m\n'
exit 1
