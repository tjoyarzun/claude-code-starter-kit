---
name: new-project
description: Start a new project from scratch — interview, pick the shape, copy the template, set up git and GitHub, make the first commit, record it in PROJECTS.md. Triggers "new project", "start a project", "I want to build", "scaffold", "create a site", "create an app", "bootstrap".
---

## What this does

Takes a project from "I have an idea" to "running locally, committed, on GitHub" in one pass —
and picks the *smallest* shape that does the job rather than defaulting to React.

## When to use it

- Starting anything new
- Turning a prototype folder into a real, tracked project
- You're unsure whether something should be a static site or a React app

## Step 1 — Interview

Ask these before touching the filesystem. A few at a time, conversationally.

1. **What is it, in one sentence?** ("A page listing my woodworking projects with photos.")
2. **Who sees it?** Just you / people you send the link to / the public.
3. **Does the content change based on who's looking, or after you publish it?**
4. **Does it need a login, a database, or live data from an API?**
5. **What should it be called?** Derive a slug: lowercase, hyphens, no spaces.
6. **Public or private repo?** Default private — it can be flipped later, and un-publishing
   something is harder than publishing it.

## Step 2 — Pick the shape, and say why

| Answers | Shape | Where |
|---|---|---|
| Static content, no login, no live data | **B — static site** | `projects/sites/<slug>/` |
| Interactive UI, data fetching, state, routing | **A — web app** | `projects/apps/<slug>/` |
| No UI at all — a script, a scheduled job | **C — script** | `projects/<slug>/` |

**Bias toward Shape B.** A personal site, a portfolio, a landing page, an event page — none
of these need React. Tell them the reasoning out loud: fewer dependencies, instant loads,
nothing that rots, and moving up to Shape A later is easy while moving down is a rewrite.

Only choose Shape A when at least one is true: the UI has real state, the same markup repeats
enough that components pay for themselves, or it talks to an API.

Say which you picked and why in one sentence, then confirm before creating anything.

## Step 3 — Create

```bash
bash library/tools/new-project.sh app <slug>     # or: site <slug>
```

The script copies the scaffold, sets `package.json`'s name, runs `git init`, and stages the
files. It refuses to overwrite an existing directory.

For Shape A, install and start:

```bash
cd projects/apps/<slug> && pnpm install && pnpm dev
```

Have **them** open http://localhost:5173 and confirm they see it. Don't move on until they
have.

## Step 4 — Make it theirs immediately

Before the first commit, replace the placeholders with real content — the title, the heading,
their name. A scaffold that still says "Hello" a week later never becomes a project.

For Shape B also update: `<title>`, the `description` meta, and the Open Graph tags.

## Step 5 — Commit and push

```bash
git add -A
git commit -m "initial commit"
gh repo create <slug> --private --source=. --push
```

If `gh` isn't authenticated, stop and run `gh auth login` first — don't work around it.

Report the repo URL.

## Step 6 — Record it

Add a row to `PROJECTS.md`: project, path, repo, live URL (blank for now),
status `active`.

## Step 7 — Hand off

Tell them, concretely:

- How to run it (`pnpm dev`, or `npx serve .`)
- Which file to edit first for the change they most want
- That `/deploy-to-vercel` makes it live whenever they're ready
- One next step sized to about 20 minutes

## Common failures

| Symptom | Cause | Fix |
|---|---|---|
| `gh: command not found` | GitHub CLI not installed | `bash library/tools/doctor.sh` and follow the hint |
| `repository already exists` | Name taken on their account | Pick another slug, or `gh repo delete` the old one |
| `pnpm install` fails on peer deps | Stale lockfile | Delete `node_modules/` and `pnpm-lock.yaml`, install again |
| Directory already exists | Project of that name exists | New slug, or work in the existing project |

## Related

- `library/guides/0-first-web-app.md` — the manual version, Shape A
- `library/guides/1-first-static-site.md` — the manual version, Shape B
- `deploy-to-vercel` — put it online
- `ship-check` — run before the first deploy
