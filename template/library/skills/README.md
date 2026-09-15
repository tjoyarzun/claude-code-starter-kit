# `skills/`

A skill is a markdown file that teaches Claude Code a repeatable job with your preferences
already baked in. `library/tools/link-skills.sh` symlinks each one into `../.claude/skills/`,
so editing a skill here takes effect immediately — no sync step to forget.

## What ships

| Skill | Use it when |
|---|---|
| `new-project` | Starting anything. Interviews you, picks the smallest shape that fits, scaffolds, sets up GitHub |
| `deploy-to-vercel` | Making it live. First deploy, auto-deploy on push, env vars, previews, rollback |
| `git-rescue` | Git scared you. Undo, unstage, conflicts, wrong branch, recovering "lost" work, committed secrets |
| `ship-check` | Before any deploy. Build, secrets, accessibility, mobile, performance, metadata → blocker vs later |
| `explain-this` | You want to understand something rather than just fix it |
| `catch-up` | Starting a session. Reconstructs where you left off from the repo itself |
| `promote-to-library` | Something earned its third reuse and belongs in the library |

## Invoking

Two ways, both fine:

- By name: `/ship-check`
- By description: "is this ready to deploy?" — Claude matches on the `description` frontmatter

That matching is why the description matters more than the body when writing one.

## Writing your own

The moment you notice yourself explaining the same multi-step process twice, that's a skill.
Just ask: *"write a skill for how I add a new page to this site"* — Claude scaffolds the file
in the right place.

```markdown
---
name: my-skill
description: One line on what it does and when. Triggers "phrase", "phrase", "phrase".
---

## What this does
## When to use it
## Steps
## Common failures
```

Then:

```bash
bash library/tools/link-skills.sh
```

and restart the Claude Code session.

## What makes a skill work

- **The description carries the triggers.** It's how Claude decides to use it at all.
- **Concrete beats comprehensive.** Exact commands. "Follow best practices" does nothing.
- **Include the failure modes.** The table of what goes wrong is usually the most valuable
  part of the file.
- **Say what the output should look like.** A skill that doesn't define "done" produces
  inconsistent results.
- **Encode your preferences, not general knowledge.** Claude already knows React. It doesn't
  know that you prefer static sites unless the app shape is genuinely needed.
