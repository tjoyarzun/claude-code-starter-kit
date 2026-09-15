# Claude Code Starter Kit

A guided setup that turns a fresh laptop into a working environment for building websites
and web apps with [Claude Code](https://claude.com/claude-code) — GitHub, Vercel, VS Code,
Node, and a reusable project workspace with its own library of scaffolds and agent skills.

You don't read this repo and follow it by hand. You clone it, open Claude Code, and point
Claude at [`START-HERE.md`](START-HERE.md). Claude interviews you, explains what each piece
is for, runs the setup with you, and stops to fix things when they break.

Works on **macOS** and **Windows** (via WSL2). Assumes you've copy-pasted a terminal command
before but aren't a full-time developer.

---

## What you end up with

```
~/dev/                         ← your workspace (name is yours to pick)
├── CLAUDE.md                  Standing instructions Claude reads every session
├── projects/
│   ├── apps/                  React web apps (Vite + TypeScript + Tailwind)
│   └── sites/                 Static sites (HTML/CSS/JS)
├── PROJECTS.md                Index of every project you've built
├── library/                   Your reusable library
│   ├── templates/             Starting points you copy for a new project
│   ├── skills/                Custom Claude Code skills (7 included)
│   ├── components/            Components promoted after a third reuse
│   ├── guides/                Step-by-step walkthroughs that actually work
│   └── tools/                 Shell scripts (doctor, new-project, link-skills)
├── shared/                    In-progress code used by 2 projects, not yet promoted
├── agent-docs/                "I learned something non-obvious" drawer
└── .claude/
    ├── settings.json          Which commands Claude may run without asking
    └── skills/                Symlinks to library/skills
```

Plus accounts and tools wired together: GitHub (code lives here), Vercel (websites go live
here), VS Code (where you edit), and Claude Code (which does most of the typing).

---

## Getting started

### 1. Install Claude Code

**macOS** — open Terminal (`Cmd+Space`, type "Terminal"):

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows** — open PowerShell as Administrator:

```powershell
wsl --install
```

Restart, open the "Ubuntu" app that appeared in your Start menu, then run the macOS command
above inside it. Everything after this point happens inside that Ubuntu window.

> Full pre-flight detail, including what to do if either command fails, is in
> [`day-0/macos.md`](day-0/macos.md) and [`day-0/windows.md`](day-0/windows.md). You can skip
> them — Claude will walk you through the same material — but they're there if the install
> itself is what breaks.

### 2. Sign in

```bash
claude
```

It opens a browser to sign in. You need a Claude Pro or Max plan, or API billing set up.
Type `/exit` to quit once you're signed in.

### 3. Clone this kit

```bash
git clone https://github.com/tjoyarzun/claude-code-starter-kit.git ~/claude-code-starter-kit
cd ~/claude-code-starter-kit
```

If `git` isn't installed yet, the command will tell you. macOS offers to install it; on
Ubuntu/WSL run `sudo apt update && sudo apt install -y git`.

### 4. Hand it to Claude

```bash
claude
```

Then paste exactly this:

```
Read START-HERE.md in this folder and set up my environment. Walk me through it.
```

That's the whole job. From here Claude asks you questions, explains each phase before doing
it, and checks that each phase worked before moving on. Expect **60–90 minutes** for the full
run, including your first deployed website.

---

## What the setup covers

| Phase | What happens | Why it matters |
|---|---|---|
| 0 | Interview — your name, what you want to build, where the workspace lives | Every later choice depends on these |
| 1 | Install Node, pnpm, git, gh, VS Code | The tools that build and ship code |
| 2 | GitHub account + SSH/auth + first test repo | Where your code lives and is backed up |
| 3 | Vercel account, linked to GitHub | Where your sites become real URLs |
| 4 | Build the workspace from `template/` | The folder structure everything lives in |
| 5 | Install the 7 skills and the permission allowlist | Teaches Claude your conventions |
| 6 | Build and deploy a real personal site | Proves the whole chain works end to end |
| 7 | Handoff — what to do tomorrow | So the momentum doesn't die |

---

## The 7 included skills

Skills are markdown files that teach Claude Code a repeatable job. Once installed, you invoke
them by name (`/new-project`) or just by describing what you want.

| Skill | What it does |
|---|---|
| `new-project` | Interviews you, scaffolds an app or site, creates the GitHub repo, first commit |
| `deploy-to-vercel` | First deploy, preview vs production, environment variables, custom domains, rollback |
| `git-rescue` | Beginner-safe recovery: undo a commit, fix a conflict, un-commit a secret, wrong branch |
| `ship-check` | Pre-deploy gate — typecheck, lint, build, secret scan, accessibility and performance sanity |
| `explain-this` | Teaching mode. Explains a file, an error, or a concept at the depth you ask for |
| `catch-up` | "Where did I leave off?" — reads recent commits and open work, proposes the next step |
| `promote-to-library` | Promotes a pattern into your library once it's earned a third reuse |

---

## Repo layout

```
claude-code-starter-kit/
├── README.md              ← you are here
├── START-HERE.md          the guided prompt Claude follows
├── day-0/                 pre-flight install notes (macos.md, windows.md, accounts.md)
├── docs/                  concepts.md, how-claude-code-works.md, troubleshooting.md
├── bootstrap/             bootstrap.sh — builds the workspace from template/
└── template/              the workspace that gets copied into place
```

## If something goes wrong

Tell Claude. Seriously — paste the error into the same session and say "this broke." That's
the intended workflow, not a fallback. [`docs/troubleshooting.md`](docs/troubleshooting.md)
covers the failures common enough to write down in advance.

## License

MIT — see [LICENSE](LICENSE). Fork it, change the conventions, make it yours.
