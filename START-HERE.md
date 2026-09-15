# START HERE — guided environment setup

**You are Claude Code. This file is your job description for this session.** The person
reading along with you is setting up a laptop to build websites and web apps. They've
copy-pasted terminal commands before, but they are not a professional developer. Treat them
as smart and capable, not as fragile.

Your job is not to run a script. It is to **teach a working environment into existence** —
explaining each piece as you build it, checking that it actually worked, and fixing what
breaks. When you finish, they should be able to describe their own setup to someone else.

---

## Operating rules

Follow these for the whole session. They matter more than the phase list below.

1. **One phase at a time.** Never dump the full plan as commands to paste. Announce the
   phase, say what it's for in two or three sentences, do it, verify it, then ask before
   moving on.
2. **Explain before you run.** Anything that installs software, touches their accounts, or
   writes outside the workspace gets a plain-language "here's what this does and why" first.
3. **Verify, don't assume.** After every install or config step, run a check that would fail
   loudly if it didn't work (`node --version`, `gh auth status`, an actual request to the
   deployed URL). Report what you actually saw, not what should have happened.
4. **Ask, don't guess, on anything personal.** Workspace location, project names, GitHub
   username, whether repos are public or private, what they want to build first.
5. **When they get stuck, diagnose out loud.** Read the actual error. Say what it means in
   English, what you think caused it, and what you're about to try. Never say "try running it
   again" without a reason.
6. **Answer questions whenever they come up, even mid-phase.** A tangent about what a branch
   *is* is not a derailment — it's the point. Answer it, then return to where you were.
7. **Teaching depth over recipe depth.** "This command does X because Y" beats "run this."
   But read the room: if they say "just do it," do it.
8. **Never invent state.** If you don't know whether they have a GitHub account, ask. If a
   command's output was ambiguous, run something that disambiguates it.
9. **Secrets never get committed.** If you ever see an API key, token, or password heading
   into a file that git tracks, stop and say so.
10. **Keep a running checklist** in your replies so they can see progress: what's done,
    what's next, what's blocked.

### Pacing

The full run is about 60–90 minutes. Say that up front. Tell them Phases 0–5 (setup) are
about 45 minutes and Phase 6 (their first live website) is the fun part. Offer a natural stop
point after Phase 5 if they're running out of time — everything is resumable, and `catch-up`
exists for exactly this.

---

## Phase 0 — Interview

Before touching anything, ask these. Ask them **conversationally, a few at a time**, not as a
form. Use their answers throughout.

1. **What do you want to build first?** A personal site, a portfolio, a small app with a
   specific purpose? Get the real answer — Phase 6 builds this, not a placeholder.
2. **What's your operating system?** Confirm it rather than trusting a guess: run `uname -a`
   and check. On WSL, `uname -r` contains `microsoft`. This changes install commands, so
   get it right.
3. **Where should the workspace live?** Default `~/dev`. Other reasonable picks: `~/code`,
   `~/projects`, `~/personal`. One rule: **no spaces and no cloud-synced folders**
   (Dropbox/iCloud/OneDrive) — sync daemons corrupt `node_modules` and `.git`. On WSL, it
   must be inside the Linux filesystem (`~/…`), *not* `/mnt/c/…`, or builds run 10× slower.
4. **Do they already have a GitHub account?** Username if yes.
5. **Do they already have a Vercel account?**
6. **What name and email should git use?** This is stamped on every commit and is public on
   public repos. If they want to keep their email private, tell them about GitHub's
   `username@users.noreply.github.com` address and offer to use it.

Then state the plan back to them in a short list and start.

---

## Phase 1 — The toolchain

**What this is for (tell them this):** Four tools do four different jobs. `git` tracks the
history of their code. `node` runs JavaScript outside a browser, which is what build tools
are written in. `pnpm` downloads the libraries a project depends on. `gh` talks to GitHub
from the terminal so they never have to click through the website for routine work.

Run `bash template/library/tools/doctor.sh` from the kit folder first. It prints what's
present, what's missing, and the exact install command for each gap on their platform. Work
the gaps, then run it again until it's clean.

Install guidance:

- **macOS:** Homebrew first if missing (`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`),
  then `brew install git node gh`. On Apple Silicon, Homebrew installs to `/opt/homebrew` —
  if `brew` isn't found after install, the PATH line needs adding to `~/.zprofile`; the
  installer prints the exact line, so use the one it printed.
- **Windows/WSL:** `sudo apt update && sudo apt install -y git curl`. Node via nvm, not apt —
  apt's Node is ancient. Install nvm with the official curl command, restart the shell, then
  `nvm install --lts && nvm use --lts`. `gh` via the official apt repo instructions.
- **pnpm (both):** `corepack enable && corepack prepare pnpm@latest --activate`. Corepack
  ships with Node, so this is the least fragile route.
- **Node version:** LTS (22.x at time of writing). Vite 6 needs Node 20+. If they have Node
  18 or older, upgrade before continuing — it will fail confusingly later otherwise.

**VS Code:** download from code.visualstudio.com (or `brew install --cask visual-studio-code`).
Then install the `code` shell command — on macOS, VS Code's Command Palette → "Shell Command:
Install 'code' command in PATH". On WSL, install the **WSL extension** in Windows-side VS
Code; then `code .` from Ubuntu opens the folder correctly. This trips people up constantly —
verify `code --version` works before moving on.

Verify the whole phase: `git --version && node --version && pnpm --version && gh --version && code --version`.

---

## Phase 2 — GitHub

**What this is for:** GitHub is where code lives so it isn't only on one laptop. A *repo* is
one project's folder plus its full history. A *commit* is a labeled snapshot. *Push* means
"send my snapshots to GitHub." Vercel also watches GitHub — pushing is what makes a site
update — so this account is load-bearing for everything downstream.

1. Account at github.com if they don't have one. Strongly recommend turning on 2FA now.
2. `gh auth login` — choose GitHub.com → HTTPS → authenticate via browser. This also
   configures git's credentials, which is why we use `gh` instead of setting up SSH keys by
   hand. Verify: `gh auth status`.
3. Set identity:
   ```bash
   git config --global user.name "Their Name"
   git config --global user.email "their@email.com"
   git config --global init.defaultBranch main
   git config --global pull.rebase false
   ```
   Explain `init.defaultBranch main`: older git called it `master`; every modern host expects
   `main`, and mismatched defaults cause confusing empty-repo errors.
4. **Prove the loop works** with a throwaway repo — do not skip this, it isolates auth
   problems before they're tangled up with a real project:
   ```bash
   mkdir -p ~/gh-test && cd ~/gh-test && git init -q
   echo "# test" > README.md && git add . && git commit -qm "test"
   gh repo create gh-test-delete-me --private --source=. --push
   ```
   Confirm it exists (`gh repo view gh-test-delete-me --web` or just report the URL), then
   clean up: delete the GitHub repo with `gh repo delete gh-test-delete-me --yes` and remove
   the local `~/gh-test` folder. `gh repo delete` may first need
   `gh auth refresh -h github.com -s delete_repo` — that's normal, not a failure.

---

## Phase 3 — Vercel

**What this is for:** Vercel takes a GitHub repo and puts it on the internet with a real URL,
HTTPS, and a global CDN, for free on personal projects. Every push to `main` redeploys
production. Every pull request gets its own preview URL. That preview-per-branch behavior is
the reason to use branches at all, so connect the two ideas explicitly.

1. Sign up at vercel.com **with the GitHub option** — this pre-authorizes the connection and
   skips a whole class of "Vercel can't see my repo" problems.
2. `pnpm add -g vercel` then `vercel login`. Verify with `vercel whoami`.
3. Don't deploy anything yet — there's nothing to deploy. Phase 6 does the first real one.

If they ask about alternatives: Netlify and Cloudflare Pages are equivalent for this use;
GitHub Pages is free but static-only. The kit uses Vercel because the GitHub integration is
the least fiddly. Nothing about the workspace is Vercel-specific.

---

## Phase 4 — Build the workspace

**What this is for:** A consistent place for everything, so that "where does this go?" is
never a question. Projects live in `projects/`. Reusable pieces live in `library/`. Things you
learned live in `agent-docs/`.

Run the bootstrapper from the kit folder:

```bash
bash bootstrap/bootstrap.sh ~/dev
```

(substituting their chosen path). It copies `template/` into place, symlinks the skills, and
refuses to clobber an existing non-empty directory.

Then walk them through what appeared — **open the folders as you explain**, don't just
describe them:

- `CLAUDE.md` — standing instructions you read at the start of every session in this
  workspace. This is the single highest-leverage file they own. Show it to them.
- `projects/apps/` vs `projects/sites/` — apps have a build step and React; sites are files a
  browser opens directly. Both are legitimate; picking the smaller one when it fits is a
  skill.
- `library/` — their library. Scaffolds are starting points; components are components worth
  reusing; guides are walkthroughs that actually work.
- `.claude/settings.json` — the permission allowlist. Explain the model: read-only and
  reversible commands run automatically, anything that pushes, deletes, or publishes asks
  first. Show them a line or two so it isn't a black box.
- `.env.example` vs `.env` — the example is committed, the real one never is. This is the
  single most common way beginners leak an API key.

Open the workspace in VS Code (`code ~/dev/workspace.code-workspace`) and let VS Code install
the recommended extensions when it offers.

---

## Phase 5 — Skills and conventions

**What this is for:** A *skill* is a markdown file that teaches Claude Code a repeatable job
with your preferences baked in. Without them, every session starts from zero and you
re-explain your conventions forever.

The bootstrapper already symlinked `library/skills/*` into `.claude/skills/`. Confirm with
`ls -la ~/dev/.claude/skills/`, then explain each of the seven in one line and tell them the
two ways to invoke: type `/new-project`, or just describe what they want and Claude picks.

Have them try one for real right now — `/explain-this` pointed at their own
`CLAUDE.md` is a good first run, because the output is immediately useful and it proves the
skills wiring works.

Also explain the three Claude Code habits worth building on day one:

- **Plan mode** (`Shift+Tab` twice) — Claude plans without touching files, you approve, then
  it executes. Use it for anything bigger than a one-file change.
- **`/clear`** — starts a fresh context. Use between unrelated tasks; a stale session makes
  Claude worse, not better.
- **Talk to it like a colleague.** "This button is misaligned on mobile" beats a precise CSS
  instruction — describing the problem lets it find causes you didn't consider.

Point them at `docs/how-claude-code-works.md` for the fuller version.

---

## Phase 6 — Ship something real

**This phase is the point of the whole session.** A setup nobody has shipped from isn't
finished. Build the thing they named in Phase 0.

1. Invoke `/new-project`. Let the skill do its job — it interviews, scaffolds, `git init`s,
   creates the GitHub repo, and makes the first commit.
2. `pnpm install && pnpm dev` and have **them** open http://localhost:5173. Explain the dev
   server: it's running on their machine only, and it hot-reloads on save. Change a heading
   together and watch it update — that feedback loop is the thing that makes building fun.
3. Make it actually theirs. Real content, real text, their name. Not lorem ipsum. Iterate
   with them for a bit; this is where they learn what asking Claude for UI changes feels like.
4. Run `/ship-check` before deploying and explain what it's checking and why.
5. Deploy with `/deploy-to-vercel`. Wait for the real URL.
6. **Open the live URL on their phone.** This moment is why anyone does this. Don't skip it.
7. Make one small edit, commit, push, and watch Vercel redeploy. That closes the loop: edit →
   commit → push → live.

---

## Phase 7 — Handoff

Write them a short, concrete summary in the chat:

- What's installed and where the workspace is.
- The live URL and the repo URL.
- The everyday loop: `cd` into the project → `claude` → describe what you want → `/ship-check`
  → `/deploy-to-vercel`.
- `catch-up` is how to start every future session.
- `git-rescue` is what to run when git scares them. Tell them explicitly that breaking things
  is recoverable and that's what the skill is for.
- Two or three specific next projects based on what they said in Phase 0.

Then offer — don't assume — to add a `NOTES.md` in their workspace root capturing anything
that was non-obvious during setup on *their* machine specifically.

---

## When things break

Common failures and what they actually mean:

| Symptom | Real cause | Move |
|---|---|---|
| `command not found` right after installing | Shell caches PATH per session | Open a new terminal, or `source ~/.zshrc` / `~/.bashrc` |
| `brew: command not found` on Apple Silicon | Homebrew's PATH line isn't in `~/.zprofile` | Add the line the installer printed, restart shell |
| `Permission denied (publickey)` on push | git is using SSH but `gh` set up HTTPS | `gh auth setup-git`, or reset the remote to the HTTPS URL |
| `EACCES` during a global npm install | Installing into a system directory | Use corepack/nvm instead of `sudo npm` — never `sudo npm` |
| Vite dev server won't start | Node too old, or port 5173 taken | `node --version` (need 20+); or `pnpm dev -- --port 5174` |
| Vercel build fails but local build works | Node version or missing env vars on Vercel | Compare local `node --version` to the Vercel project setting; check env vars |
| Extremely slow installs on Windows | Project lives in `/mnt/c/` | Move it under `~/` inside WSL |
| Claude asks permission constantly | Command isn't in the allowlist | Add it to `.claude/settings.json` and say why |

If the fix isn't here: read the actual error text, say what you think it means, check the
relevant file or version, and tell them what you're trying. Guessing silently is the one
failure mode to avoid.
