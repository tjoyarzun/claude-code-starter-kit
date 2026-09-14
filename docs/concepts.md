# Concepts — the vocabulary

Not a tutorial. Just definitions, in the order you'll meet them, so nobody has to pretend
they know what a "build step" is.

## Code and history

**Repository (repo)** — one project's folder plus its complete history. `git init` turns a
folder into one.

**Commit** — a labeled snapshot of every file at a moment in time. Commits are cheap; make
them often. A good message says *why*, not *what* ("fix mobile nav overlap" beats "update
CSS").

**Branch** — a parallel line of commits. `main` is the real one. You make a branch to try
something without risking `main`, then merge it back if it works. For solo projects you can
work directly on `main` for a while — but branches are what give you free preview deploys, so
they pay off sooner than you'd think.

**Remote** — a copy of the repo somewhere else, usually GitHub. `origin` is the conventional
name for the main one.

**Push / pull** — send your commits to the remote / bring the remote's commits down.

**Pull request (PR)** — a proposal to merge one branch into another, with a place to review
the diff. Solo, it's a nice checkpoint plus a free preview URL. On a team, it's the whole
review process.

**`.gitignore`** — a list of files git should pretend don't exist. `node_modules/` (huge,
reinstallable) and `.env` (secret) live here.

## Building and running

**Package manager (`pnpm`)** — installs the libraries your project depends on, listed in
`package.json`, into `node_modules/`. `pnpm` is a faster, disk-efficient `npm`. `npm`, `yarn`,
and `bun` do the same job.

**`package.json`** — the project's ID card: name, dependencies, and the scripts you can run.

**`pnpm dev`** — starts a development server on your machine (usually
http://localhost:5173) that rebuilds and refreshes the page as you save. Only you can see it.

**`pnpm build`** — produces the optimized `dist/` folder that actually gets deployed. It's a
different code path from `dev`, which is why "works locally, breaks in production" happens —
always run `build` before you deploy.

**Build step** — the translation from what you write (TypeScript, JSX, Tailwind classes) into
what browsers understand (JS, HTML, CSS). Static sites skip it; React apps need it.

**Vite** — the tool that does that translation. Fast dev server, optimized production build.

**Deploy** — putting the built output somewhere the public can reach.

## The stack in your scaffold

**React** — a library for building UI out of reusable components instead of one long HTML
file.

**TypeScript** — JavaScript plus type annotations. It catches "you passed a string where a
number goes" before you run the code. Strict mode is on in the scaffold; that's deliberate —
the errors it raises are bugs you'd otherwise find in production.

**Tailwind CSS** — styling via small utility classes in your markup (`className="flex gap-4
text-lg"`) rather than a separate stylesheet. Looks noisy for a day, then stops mattering.

**shadcn/ui** — pre-built components (button, dialog, form) you copy into your project and
own outright. Not a dependency — actual files in your `src/`, editable.

**TanStack Query** — manages data fetched from an API: loading states, caching, refetching.
Included in the app scaffold because hand-rolling that always goes badly.

## Secrets

**Environment variable** — a value injected at build or run time instead of being written
into your code. API keys go here.

**`.env`** — the local file holding them. **Never committed.** **`.env.example`** — the same
file with the values removed, committed, so the next person knows which keys are needed.

**The `VITE_` prefix rule:** in a Vite project, only variables starting with `VITE_` are
exposed to browser code — and anything exposed to browser code is **publicly visible to
anyone who opens devtools**. Never prefix a real secret with `VITE_`. If a key must stay
secret, it belongs on a server, not in a web page.

## Hosting

**Static site** — plain files. Fast, cheap, unbreakable. Right answer more often than people
think.

**SPA (single-page app)** — one HTML file, JavaScript swaps the content as you navigate.
What the React scaffold produces.

**CDN** — servers worldwide that cache your site so it loads fast everywhere. Vercel does this
automatically.

**Production vs preview** — production is the real URL from `main`. Previews are per-branch
URLs for trying things. Same build, different audience.

## Claude Code

**Session** — one conversation. It remembers within itself, not across sessions. `/clear`
starts fresh.

**Context** — everything Claude currently has in mind: your messages, files it read, command
output. It's finite; that's why `/clear` between unrelated tasks makes it sharper.

**`CLAUDE.md`** — instructions loaded automatically at session start for a given folder. Your
conventions, written once.

**Skill** — a markdown file teaching a repeatable job. `/new-project` is a skill.

**Permission allowlist** (`.claude/settings.json`) — which commands run without asking. Safe
reads auto-allow; pushes, deletes, and publishes ask.

**Plan mode** (`Shift+Tab` twice) — Claude proposes a plan without editing anything; you
approve before it acts.
