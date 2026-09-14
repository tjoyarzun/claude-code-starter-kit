---
name: graduate-to-pantry
description: Promote a component, pattern, or script from a project into the pantry library once it has earned a third reuse — generalize it, strip project specifics, write the README, commit with provenance. Triggers "graduate", "add to pantry", "make this reusable", "move this to my library", "I keep rewriting this".
---

## What this does

Takes something that has proven itself in real projects and moves it into `pantry/` so the
next project starts with it.

Equally important: it **declines** to graduate things that haven't earned it yet.

## The bar

**Three uses.** Not two.

- Once is a solution to one problem.
- Twice is a coincidence.
- Three times is a pattern, and by then you know which parts vary.

Graduating at one or two is how libraries fill with abstractions that fit nothing. The cost is
invisible and permanent: every future project gets bent to fit a shape that was guessed.

Check honestly before proceeding:

```bash
grep -rl "<component-or-function-name>" ~/dev/projects --include='*.tsx' --include='*.ts' --include='*.js' 2>/dev/null
```

Fewer than three hits → say so, and suggest waiting. Offer to note it in `agent-docs/` as a
candidate instead. This is a real answer, not a stall — say it plainly and move on.

## Step 1 — Pick the destination

| What it is | Goes to |
|---|---|
| A UI component (form, modal, card, toggle) | `pantry/snacks/<name>/` |
| A shell script | `pantry/tools/<name>.sh` |
| A repeatable multi-step job for Claude | `pantry/skills/<name>/SKILL.md` |
| A walkthrough of a task with traps in it | `pantry/cookbooks/<n>-<name>.md` |
| A change to how every new project starts | `pantry/scaffold/<shape>/` |
| A thing you learned, not a thing you reuse | `agent-docs/<topic>.md` |

## Step 2 — Compare the copies

Open all three versions side by side. The diff between them *is* the API.

- What's identical → the core. Keep it as-is.
- What differs → a prop, a parameter, or an option.
- What only one version needs → **leave it out.** Do not add a prop for a case that occurred
  once; the third project can add it.

Take the **best** version as the base, not the newest.

## Step 3 — Generalize, minimally

- Strip project-specific names, copy, colors, and hardcoded URLs.
- Pull hardcoded values into props/parameters with sensible defaults.
- Remove imports from that project's own modules — a snack must work after a bare `cp -r`.
- Keep the styling approach consistent with the scaffold (Tailwind classes for Shape A).
- **Resist adding features.** The graduated version should do what the three copies did, no
  more.

## Step 4 — Write the README

Every snack gets one. Four sections, short:

```markdown
# <name>

What it does, in two sentences.

## Usage
<a real, copy-pasteable example>

## Props
| Prop | Type | Default | Notes |

## Notes
Anything surprising. What it deliberately doesn't do.
```

A snack without a README is a mystery box six months from now.

## Step 5 — Prove it still works

```bash
bash pantry/tools/new-project.sh app scratch-test
# copy the snack in, use it, then:
cd projects/apps/scratch-test && pnpm install && pnpm build
```

Then delete the scratch project. **Something in the library that doesn't work is worse than
nothing** — it fails at the exact moment someone is excited to start.

For a skill: run `bash pantry/tools/link-skills.sh`, restart the session, and invoke it once.

## Step 6 — Index and commit

Add it to the relevant README index (`snacks/README.md`, `cookbooks/README.md`,
`tools/README.md`).

Commit with provenance — where it came from matters when you later wonder why it's shaped this
way:

```bash
git add -A
git commit -m "graduate: <name> snack (from my-portfolio, 3rd reuse)"
```

## Step 7 — Leave the originals alone

Do **not** go back and rewire the three projects to use the pantry version. They're fine.
Pantry is a shelf, not a dependency — the whole point is that no project breaks when the
library changes. Retrofitting reintroduces exactly the coupling this design avoids.

## Related

- `pantry/README.md` — the library rules
- `pantry/CLAUDE.md` — scaffold conventions to match
