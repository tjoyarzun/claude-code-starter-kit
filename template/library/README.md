# `library/`

Your personal library. Everything here exists so that the second time you do something is
faster than the first.

```
library/
├── templates/
│   ├── web-app/       Shape A starting point — Vite 6 + React 18 + TypeScript + Tailwind 3.
│   │                  Copy into projects/apps/<slug>/.
│   └── static-site/   Shape B starting point — HTML/CSS/JS, no build step.
│                      Copy into projects/sites/<slug>/.
├── skills/            Markdown skills Claude Code loads on demand (symlinked into
│                      ../.claude/skills/). Seven ship with the kit.
├── components/        Copy-and-tweak components. Each one works after a `cp -r`.
├── guides/            Walkthroughs that actually work — exact commands, no prose.
└── tools/             Shell scripts: doctor, link-skills, new-project.
```

## The one idea

**This is a shelf, not a dependency.** Projects copy from it at the start and then drift
however they need to. Nothing here is imported at build time, so no project ever breaks
because you edited the library.

The tradeoff is deliberate: you trade automatic propagation for the freedom to change a
template without auditing every project that used it.

## Starting a project

```bash
bash library/tools/new-project.sh app  my-app     # → projects/apps/my-app/
bash library/tools/new-project.sh site my-site    # → projects/sites/my-site/
```

Or just run `/new-project` in Claude Code, which does the same plus GitHub setup.

## Promotion — how things get here

Something belongs in `library/` when you've written it **three times**. Twice is a
coincidence; three times is a pattern.

1. Build it in a project. Let it be messy.
2. Build it again somewhere else. Notice the shape.
3. The third time, run `/promote-to-library` — it generalizes the version you have, strips
   project-specific details, writes the README, and commits with a note about where it came
   from.

Resist promoting early. A premature abstraction in your library is worse than three copies,
because you'll bend the next project to fit it.

**Where does the second copy live?** In the second project. There is no staging area, and
that's deliberate — a half-generalized copy sitting in a third location is one more thing to
keep in sync with nothing to sync it. Duplication *is* the signal you're waiting for. Let the
two copies drift; the differences between them are what tells you which parts are the pattern
and which were local accidents. If you want the second copy findable later, one line in
`agent-docs/` costs nothing.

`/promote-to-library` searches `projects/` for the copies when the time comes, so you don't
have to remember where they were.

## Rules

1. **No secrets.** `.env.example` only, never `.env`.
2. **Everything here runs.** A broken scaffold costs more than no scaffold — if you change
   one, create a throwaway project from it and confirm it still starts.
3. **Every folder has a README** saying what's in it and how to use it. Including the ones
   that are currently empty.
