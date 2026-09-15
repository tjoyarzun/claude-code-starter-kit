# Workspace agent context

This is my personal project workspace. Layout and philosophy live in
[library/README.md](library/README.md) — this file is behavior rules only.

Claude Code reads this automatically at the start of every session in this folder or below
it. **Edit it whenever you catch yourself correcting Claude the same way twice.**

## Posture: I'm learning while I build

The bar is real engineering — typed, working, deployed — but I'm still learning, and I'd
rather understand the thing than get a fix I can't explain.

- **At any point of confusion, stop and check.** Read the docs, read the source, run the
  thing. Don't paper over uncertainty with a guess that happens to run.
- **Teach while you work.** When you do something non-obvious, say why in a sentence. When
  I ask how something works, explain the mechanism, not just the recipe.
- **Cite `file:line`** when you reference behavior, so I can go look.
- **"I'm not sure, let me check" is the right answer.** Confident bullshitting is the failure
  mode to avoid — I can't catch it yet, so don't make me.
- **Tell me when I'm asking for the wrong thing.** If there's a simpler approach, say so
  before building the complicated one.

## Three project shapes

Identify the shape first — the right answers depend on it.

- **Shape A — Web app.** Vite 6 + React 18 + TypeScript strict + Tailwind 3 + shadcn/ui.
  Lives in `projects/apps/`. Starts from `library/templates/web-app/`.
- **Shape B — Static site.** HTML + CSS + vanilla JS, no build step (Astro if it grows
  content-heavy). Lives in `projects/sites/`. Starts from `library/templates/static-site/`.
- **Shape C — Script/automation.** Python 3.11+ with `uv`, or a Node script. Runs locally or
  on a schedule.

**Default to the smallest shape that does the job.** A personal site with five pages does not
need React. Choosing Shape B when Shape B is enough is a skill, not a compromise.

## The `library/` directory

`library/` is a shelf you copy from, not a dependency you link to.

- Projects **copy** what they need at start, then drift freely. That's intended.
- Claude Code loads `library/skills/` automatically via symlinks in `.claude/skills/`.
- **Promotion is an explicit copy.** When a project invents something worth reusing, copy it
  back into `library/` with a commit message naming where it came from. Rule of thumb:
  promote on the 3rd reuse, not the 1st — two uses is a coincidence.
- **The second copy lives in the second project**, not in a staging folder. Duplication is
  the signal; the drift between two copies is what shows you the real pattern.
- Nothing in `library/` is imported at build time. Every project ships self-contained.

## Working agreements

- **Use `pnpm`**, not npm or yarn. Mixing lockfiles causes real bugs.
- **Ask before adding a dependency.** Most of the time the answer is twenty lines of code.
- **Run `pnpm build` before every deploy.** The dev server is a different code path; "works
  in dev" is not evidence.
- **Commit often, in small pieces.** Commit messages say *why*, not *what*.
- **Never commit `.env`,** or any key, token, or password. If one lands in a commit, stop and
  tell me — deleting the line later doesn't remove it from history.
- **Plan before anything that touches more than one file.** Show me the plan first.
- **Don't refactor code I didn't ask about.** Mention it, let me decide.

## Key invariants

- `.env` is gitignored everywhere; `.env.example` is committed.
- Each project under `projects/` has its own `.git/`. **The workspace root is not a repo** —
  don't run `git init` here.
- Permissions live in [`.claude/settings.json`](.claude/settings.json). Reads and reversible
  commands auto-allow; push, delete, publish, and write-style network calls ask first. When
  you need a new permission, add it and tell me why.
- In a Vite app, **anything prefixed `VITE_` is visible to anyone who opens devtools.** Real
  secrets never get that prefix and never live in browser code.

## Directory layout

```
.
├── projects/
│   ├── apps/        Shape A — React web apps
│   └── sites/       Shape B — static sites
├── PROJECTS.md      Index of every project, with repo and live URL
├── library/         templates, skills, components, guides, tools
├── agent-docs/      Notes on things I learned that weren't obvious
└── .claude/         settings.json + skills symlinks
```

## Starting a new project

Use the `/new-project` skill. It interviews me, picks the shape, copies the scaffold, sets up
git and GitHub, and makes the first commit. Manual equivalent:

```bash
bash library/tools/new-project.sh app <slug>     # or: site <slug>
```

## When stuck

1. `agent-docs/` — did I already learn this?
2. `library/guides/` — is there a walkthrough?
3. `bash library/tools/doctor.sh` — is the environment itself broken?
4. Then read the actual docs or source. Don't guess.
