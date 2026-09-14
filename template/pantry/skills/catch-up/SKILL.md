---
name: catch-up
description: Start a session by reconstructing where you left off — recent commits, uncommitted work, deploy state, TODOs — and propose the next step. Triggers "catch up", "where did I leave off", "what was I doing", "start session", "what's next", "pick up where I left off".
---

## What this does

Claude Code doesn't remember yesterday. This reconstructs it from what the repo actually
records, so the first ten minutes of a session aren't spent re-orienting.

## Step 1 — Where are we?

```bash
pwd
git status --short --branch
git log --oneline -10
git branch --show-current
```

If they're in the workspace root rather than a project, list what's in `projects/apps/` and
`projects/sites/` with modification times and ask which one.

## Step 2 — What's unfinished?

Uncommitted changes are the most important signal — that's literally where they stopped.

```bash
git status --short
git diff --stat
git stash list
```

If there are uncommitted changes, **read the diff** and say what was in progress. "You were
partway through adding a contact form — `ContactForm.tsx` is new and the route isn't wired up
yet" is the useful output. Not "you have 3 modified files."

## Step 3 — What did the last session accomplish?

```bash
git log -5 --format='%h %ad %s' --date=relative
```

Summarize the arc, not the list: "Last Tuesday you built out the projects grid and fixed the
mobile nav."

## Step 4 — Is it deployed and current?

```bash
git log origin/main..HEAD --oneline 2>/dev/null   # commits not pushed
```

If there are unpushed commits, say so — it usually means the live site is behind. If the
project has a Vercel link, mention checking the dashboard.

## Step 5 — What's explicitly pending?

```bash
grep -rn "TODO\|FIXME\|HACK" --include='*.ts' --include='*.tsx' --include='*.js' --include='*.css' --include='*.html' . 2>/dev/null | grep -v node_modules | head -20
```

Also check the project README and `pantry/solutions/README.md` for a status note.

## Step 6 — Report and propose

Keep it short. Six lines, not a document:

```
📍 my-portfolio (projects/sites/my-portfolio) — branch main

Last session (3 days ago): built the projects grid, fixed mobile nav.

In progress: ContactForm.tsx is new and uncommitted; the form isn't
wired to a submit handler yet.

Pending: 2 TODOs (alt text on hero, favicon).
Deploy: 2 commits not pushed — live site is behind.

Suggested next: finish the contact form submit handler (~20 min),
then push and deploy.
```

Then ask: "Want to pick that up, or something else?" **Propose, don't start.** They may have
opened the session for something entirely different.

## If the trail is cold

Nothing uncommitted, nothing pending, last commit a month ago — say that plainly and offer
options instead of manufacturing a next step:

- Pick up a LATER item from the last `ship-check`
- Start something new (`/new-project`)
- Check whether the deployed site still works

## Related

- `ship-check` — before deploying whatever gets finished
- `git-rescue` — if the uncommitted work looks tangled
