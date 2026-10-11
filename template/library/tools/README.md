# `library/tools/`

Shell scripts you run directly. Each one does a single job and prints what it did.

| Script | What it does |
|---|---|
| `doctor.sh` | Checks the whole toolchain — installs, versions, auth, workspace wiring — and prints the exact fix command for anything missing. Run it whenever something feels broken. |
| `link-skills.sh` | Symlinks `library/skills/*` into `.claude/skills/` so Claude Code can find them. Re-run after adding a skill. |
| `new-project.sh` | Copies a scaffold into `projects/` and runs `git init`. The non-interactive core of the `/new-project` skill. |
| `install-plugins.sh` | Installs the Claude Code plugins this workspace expects (`vercel`, `agent-skills`) at user scope. Re-run after a fresh machine. |

```bash
bash library/tools/doctor.sh
bash library/tools/link-skills.sh
bash library/tools/install-plugins.sh
bash library/tools/new-project.sh app my-new-app
```

## Adding your own

Keep them boring and safe:

- `set -euo pipefail` at the top — stop on the first error instead of continuing into a mess.
- Print what you did. A script that succeeds silently is indistinguishable from one that
  did nothing.
- Never delete without printing the path first.
- Take the workspace path as an argument with a sensible default, so the script works from
  anywhere.
