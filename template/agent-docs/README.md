# `agent-docs/`

The "I learned something non-obvious" drawer. Cross-project findings, tool quirks, and
decisions worth remembering.

Write here the moment something takes more than one try to figure out. The cost is two
minutes; the payoff is not re-deriving it in four months.

## What belongs here

- Non-obvious tool behavior — CLI quirks, API gotchas, deploy edge cases
- Why you chose X over Y (a lightweight decision record)
- Patterns used in more than one project but not yet promoted to `library/`
- Vocabulary — when a word means something specific in your projects

## What doesn't

- Project-specific notes → that project's own README or `agent-docs/`
- Anything already in the scaffold or a library README
- Step-by-step walkthroughs → `library/guides/`

## Format

One file per finding, named for what it's about: `vercel-env-vars.md`,
`tailwind-dark-mode.md`. Short is fine — three lines that save an hour count.

```markdown
# <thing>

**What happened:** …
**Why:** …
**What to do next time:** …
```

## Index

*(empty — add your first entry when something surprises you)*
