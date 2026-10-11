# How Claude Code works (the mental model)

The six things that separate people who get a lot out of Claude Code from people who get
frustrated by it.

## 1. Context is finite, and you steer it

Claude sees: your messages, files it has read this session, and command output. It does *not*
see your whole computer, and it does not remember yesterday.

Practical consequences:

- **`/clear` between unrelated tasks.** A session full of an old debugging thread makes Claude
  worse at your new question, not better.
- **Point at files.** "Look at `src/components/Nav.tsx`" is stronger than describing the file.
- **Long sessions drift.** If answers start feeling off, `/clear` and restate the goal.

## 2. `CLAUDE.md` is your highest-leverage file

It's loaded automatically at the start of every session in that folder. Anything you'd
otherwise repeat belongs there: stack choices, conventions, things to never do.

Good entries are specific and behavioral:

```markdown
- Use pnpm, never npm.
- All components are function components with named exports.
- Don't add a dependency for something under 20 lines of code.
- Ask before installing anything new.
```

Bad entries are vague ("write good code") or restate the obvious. When you catch yourself
correcting Claude the same way twice, that correction belongs in `CLAUDE.md`. Just say
"add that to CLAUDE.md" and it will.

## 3. Skills are repeatable jobs

A skill is a markdown file with a name, a description of when to use it, and steps. Your
workspace ships seven. They live in `library/skills/` and are symlinked into `.claude/skills/`.

Invoke by name (`/ship-check`) or just describe the goal and let Claude match. Writing your
own is the natural next step once you notice yourself explaining the same multi-step process
twice — ask Claude to write it and it will scaffold the file for you.

## 4. Plugins are skills someone else maintains

A skill you wrote lives in your workspace. A *plugin* is a published bundle — skills, agents,
sometimes hooks — that you install once and get everywhere:

```bash
claude plugin list                 # what you have
claude plugin install <name>       # add one
claude plugin uninstall <name>     # remove one
```

Your setup installs two: `vercel` (deploys, env vars, domains) and `agent-skills`
(`/plan`, `/test`, `/review`, `/ship`). They're user-scope, so they work in every folder, and
they load at session start — install one mid-session and you'll need to restart before it
shows up.

Two things worth knowing before you add more:

- **Every plugin costs context.** Its skill descriptions load into every session whether you
  use them or not. A dozen plugins is a real tax on how much room Claude has for your actual
  code. `claude plugin details <name>` shows the projected cost.
- **A plugin can ship hooks**, which run automatically and can change how Claude behaves in
  every session — including overriding instructions you wrote. That's useful when you chose it
  and surprising when you didn't. Read what a plugin includes before installing it, the same
  way you'd read a dependency.

## 5. Permissions are a dial, not a wall

`.claude/settings.json` lists commands that run without asking. The shipped default: reading,
searching, typechecking, linting, building, and installing run freely; pushing, deleting,
publishing, and write-style network calls ask first.

If you're being asked constantly about something safe, add it to the `allow` list. If
something makes you nervous, move it to `ask`. Tuning this is normal — it's your dial.

Three modes worth knowing:

- **Default** — asks for anything not allowlisted.
- **Accept edits** (`Shift+Tab` once) — file edits stop asking, commands still ask. Where most
  people live.
- **Plan mode** (`Shift+Tab` twice) — no changes at all until you approve a plan.

## 6. Describe problems, not solutions

The instinct is to specify the fix: "change the margin on line 40 to 2rem." That constrains
Claude to your diagnosis, which is often wrong.

Better: "the nav overlaps the hero on my phone." Now it can read the file, find the real
cause, and tell you what it was — and you learn something.

Same for errors: paste the whole error, including the stack trace. Don't summarize it.

## Everyday commands

| Command | What it does |
|---|---|
| `claude` | Start a session in the current folder |
| `/clear` | Wipe context, keep the session |
| `/exit` | Quit |
| `Shift+Tab` | Cycle: default → accept-edits → plan mode |
| `Esc` | Interrupt what Claude is doing, immediately |
| `Esc Esc` | Rewind to an earlier point in the conversation |
| `/init` | Generate a `CLAUDE.md` for an existing project |
| `claude --continue` | Resume your last session in this folder |

## A good working rhythm

1. `cd` into the project, run `claude`.
2. `/catch-up` — what did I do last time, what's next.
3. Describe what you want. Use plan mode if it's more than a one-file change.
4. Look at the result in the browser yourself. Claude can't see your screen unless you tell
   it what you see (or paste a screenshot).
5. `/ship-check`, then `/deploy-to-vercel`.
6. When something was non-obvious, say "write that down in agent-docs" — future you won't
   re-derive it.

## Things it's bad at (so you're not surprised)

- **Seeing your UI.** It knows the code, not the rendering. Describe what looks wrong, or
  paste a screenshot.
- **Your intent.** It will happily build the thing you asked for instead of the thing you
  wanted. Ambiguity is on you to resolve.
- **Very recent releases.** If a library shipped a breaking change last month, it may be
  working from older docs. Ask it to check the actual docs when versions matter.
- **Knowing when to stop.** Left alone it will keep adding. "Is there a simpler version of
  this?" is a question worth asking often.
