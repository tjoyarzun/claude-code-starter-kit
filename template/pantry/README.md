# `pantry/`

Your personal library. Everything here exists so that the second time you do something is
faster than the first.

```
pantry/
├── scaffold/
│   ├── web-app/       Shape A starting point — Vite 6 + React 18 + TypeScript + Tailwind 3.
│   │                  Copy into projects/apps/<slug>/.
│   └── static-site/   Shape B starting point — HTML/CSS/JS, no build step.
│                      Copy into projects/sites/<slug>/.
├── skills/            Markdown skills Claude Code loads on demand (symlinked into
│                      ../.claude/skills/). Seven ship with the kit.
├── snacks/            Copy-and-tweak components. Each one works after a `cp -r`.
├── cookbooks/         Walkthroughs that actually work — exact commands, no prose.
├── tools/             Shell scripts: doctor, link-skills, new-project.
└── solutions/         Index of every project you've built, with its path, repo, and status.
```

## The one idea

**This is a shelf, not a dependency.** Projects copy from it at the start and then drift
however they need to. Nothing here is imported at build time, so no project ever breaks
because you edited the pantry.

The tradeoff is deliberate: you trade automatic propagation for the freedom to change a
scaffold without auditing every project that used it.

## Starting a project

```bash
bash pantry/tools/new-project.sh app  my-app     # → projects/apps/my-app/
bash pantry/tools/new-project.sh site my-site    # → projects/sites/my-site/
```

Or just run `/new-project` in Claude Code, which does the same plus GitHub setup.

## Graduation — how things get here

Something belongs in `pantry/` when you've written it **three times**. Twice is a
coincidence; three times is a pattern.

1. Build it in a project. Let it be messy.
2. Build it again somewhere else. Notice the shape.
3. The third time, run `/graduate-to-pantry` — it generalizes the version you have, strips
   project-specific details, writes the README, and commits with a note about where it came
   from.

Resist graduating early. A premature abstraction in your library is worse than three copies,
because you'll bend the next project to fit it.

## Rules

1. **No secrets.** `.env.example` only, never `.env`.
2. **Everything here runs.** A broken scaffold costs more than no scaffold — if you change
   one, create a throwaway project from it and confirm it still starts.
3. **Every folder has a README** saying what's in it and how to use it. Including the ones
   that are currently empty.
