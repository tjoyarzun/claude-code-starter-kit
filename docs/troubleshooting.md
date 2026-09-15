# Troubleshooting

The failures common enough to write down in advance. **First move for anything not listed: paste
the full error into Claude Code and say what you were doing.** That's the intended workflow.

## Terminal and PATH

**`command not found` right after installing something**
Your shell cached its PATH when the window opened. Open a new terminal, or
`source ~/.zshrc` (macOS) / `source ~/.bashrc` (WSL).

**`brew: command not found` on a new Mac**
Apple Silicon puts Homebrew in `/opt/homebrew`, which isn't on PATH by default. The installer
printed two `eval` lines at the end — run them. To find them again:
`echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile && source ~/.zprofile`.

**`permission denied` running a script**
`bash script.sh` instead of `./script.sh`, or `chmod +x script.sh` first.

## git and GitHub

**`Permission denied (publickey)`**
git is trying SSH while `gh` authenticated over HTTPS. Fix: `gh auth setup-git`. Or point the
remote at HTTPS: `git remote set-url origin https://github.com/USER/REPO.git`.

**`fatal: not a git repository`**
You're not in the project folder, or it was never `git init`ed. `pwd` to check where you are.

**`failed to push some refs` / `rejected`**
The remote has commits you don't. `git pull` first, resolve any conflict, then push.

**Merge conflict**
git marks both versions in the file with `<<<<<<<` and `>>>>>>>`. Don't panic and don't
hand-edit blind — run `/git-rescue` and let it walk you through it.

**"I committed a secret"**
Stop. Don't just delete the line in a new commit — it stays in history. Run `/git-rescue`; it
covers rewriting the commit and, crucially, rotating the key. **Assume any key that reached
GitHub is compromised, even for a minute, even on a private repo.**

## Node, pnpm, installs

**`Unsupported engine` or a Vite crash on startup**
Node too old. `node --version` — need 20+. macOS: `brew upgrade node`. WSL:
`nvm install --lts && nvm use --lts`.

**`EACCES: permission denied` during a global install**
Never `sudo npm install -g`. Use `corepack` for pnpm and `nvm` for Node — both install into
your home directory where you already have permission.

**`pnpm: command not found` after installing Node**
`corepack enable && corepack prepare pnpm@latest --activate`.

**Weird module errors after pulling changes**
Dependencies changed. `pnpm install`. If it persists, delete `node_modules/` and
`pnpm-lock.yaml`, then `pnpm install` fresh.

**Install takes forever on Windows**
The project is on `/mnt/c/`. Move it under `~/` inside WSL. This is the single biggest WSL
performance trap.

## Dev server

**Port 5173 already in use**
Another dev server is running. `pnpm dev -- --port 5174`, or find and stop the other one.

**Page doesn't reload when I save**
On WSL: the project is on the Windows filesystem and file-watching doesn't cross the boundary.
Move it under `~/`. On macOS: hard-refresh (`Cmd+Shift+R`); if that fixes it, it's browser
cache, not the server.

**Blank white page**
Open the browser console (`F12` or `Cmd+Option+J`) — the real error is there, not in the
terminal. Paste it to Claude.

## Vercel

**"No GitHub repositories found"**
Vercel's GitHub app doesn't have access to that repo. vercel.com → Settings → Git → configure
the GitHub app and grant it the repo (or all repos).

**Build fails on Vercel but works locally**
Three usual causes, in order of likelihood:
1. Environment variables exist in your local `.env` but were never added in Vercel's project
   settings. `.env` is gitignored — Vercel never saw it.
2. Node version mismatch. Set it in Vercel → Settings → General → Node.js Version.
3. Case-sensitive imports. macOS doesn't care about `./Button` vs `./button`; Vercel's Linux
   builders do.

Always run `pnpm build` locally before deploying — it catches most of this.

**Deployed but showing an old version**
Check that the deploy actually finished (Vercel dashboard), then hard-refresh. Vercel's CDN
invalidates on deploy, so a stale page is almost always browser cache.

**404 on a route that works locally**
An SPA needs all paths rewritten to `index.html`. Vercel does this automatically for detected
frameworks; if you're on a custom setup, add a `vercel.json` rewrite. Ask Claude.

## Claude Code

**Asks permission for everything**
The command isn't allowlisted. Add it to `.claude/settings.json` under `permissions.allow`,
or say "add this to my allowlist and explain why."

**Doesn't seem to know my conventions**
Check that `CLAUDE.md` is in the folder you started `claude` from (or an ancestor). Run
`/memory` to see what's loaded.

**Skills aren't showing up**
`ls -la ~/dev/.claude/skills/` — you should see symlinks into `library/skills/`. If not,
re-run `bash ~/dev/library/tools/link-skills.sh`.

**Answers got vague or it forgot earlier context**
The session is too long. `/clear` and restate the goal.

**It edited something I didn't want**
`Esc Esc` rewinds the conversation. For files already changed: `git diff` to see exactly what
changed, `git checkout -- <file>` to revert one. This is the argument for committing often.
