#!/usr/bin/env bash
# install-plugins.sh — install the Claude Code plugins this workspace expects.
#
# Usage: bash install-plugins.sh
#
# Plugins install at USER scope: they apply to every project on this machine,
# not just this workspace. Safe to re-run — anything already installed is left
# alone. Never fails the caller; a plugin that won't install is a warning.

set -uo pipefail

ok()   { printf '  \033[32m✓\033[0m %s\n' "$*"; }
skip() { printf '  \033[33m•\033[0m %s\n' "$*"; }
bad()  { printf '  \033[31m✗\033[0m %s\n' "$*" >&2; }
hint() { printf '      \033[2m↳ %s\033[0m\n' "$*"; }

# repo | marketplace name | plugin | what it gives you
#
# The marketplace name comes from the repo's own manifest, NOT from the repo
# name — addyosmani/agent-skills registers itself as "addy-agent-skills". Using
# the repo name in the install command is the usual way this goes wrong.
PLUGINS=(
  "anthropics/claude-plugins-official|claude-plugins-official|vercel|deploys, env vars, domains, rollbacks"
  "addyosmani/agent-skills|addy-agent-skills|agent-skills|plan, test, review and ship workflows"
)

if ! command -v claude >/dev/null 2>&1; then
  bad "claude not found on PATH — skipping plugins"
  hint "Install Claude Code, then re-run: bash $0"
  exit 0
fi

INSTALLED="$(claude plugin list 2>/dev/null || true)"

for entry in "${PLUGINS[@]}"; do
  IFS='|' read -r repo market plugin purpose <<< "$entry"

  if printf '%s' "$INSTALLED" | grep -q "${plugin}@${market}"; then
    skip "$plugin already installed"
    continue
  fi

  # No-op when the marketplace is already known.
  claude plugin marketplace add "$repo" >/dev/null 2>&1

  if claude plugin install "${plugin}@${market}" --scope user >/dev/null 2>&1; then
    ok "$plugin — $purpose"
  else
    bad "$plugin failed to install"
    hint "By hand: claude plugin install ${plugin}@${market} --scope user"
  fi
done

printf '      \033[2mRestart Claude Code to load them.\033[0m\n'
