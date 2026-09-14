# Day 0 — macOS pre-flight

You only need this file if you want to install things yourself before handing off to Claude,
or if the one-liner in the README failed. Claude covers the same ground in Phase 1.

Everything happens in **Terminal** — press `Cmd+Space`, type "Terminal", hit Enter.

## 1. Command Line Tools

```bash
xcode-select --install
```

A dialog appears; click Install and wait (a few minutes). This gives you `git` and the
compilers other tools expect. If it says "already installed," you're fine.

## 2. Homebrew

The package manager for macOS — it installs developer tools the way the App Store installs apps.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**On Apple Silicon (M1/M2/M3/M4), read the last few lines of output.** Homebrew installs to
`/opt/homebrew`, which isn't on your PATH by default, and it prints two commands to fix that.
Run them. If you skip this, every `brew` command after this says "command not found."

Verify:

```bash
brew --version
```

## 3. The tools

```bash
brew install git node gh
brew install --cask visual-studio-code
corepack enable && corepack prepare pnpm@latest --activate
```

| Tool | What it's for |
|---|---|
| `git` | Tracks the history of your code |
| `node` | Runs JavaScript outside the browser — build tools need it |
| `pnpm` | Installs the libraries your projects depend on |
| `gh` | GitHub from the terminal (login, create repos, open PRs) |
| VS Code | The editor |

## 4. The `code` command

Open VS Code → `Cmd+Shift+P` → type "shell command" → select **"Shell Command: Install 'code'
command in PATH"**. Now `code .` opens the current folder from the terminal.

## 5. Claude Code

```bash
curl -fsSL https://claude.ai/install.sh | bash
claude
```

The first `claude` run opens a browser to sign in. You need a Claude Pro or Max plan, or API
billing configured.

## 6. Check yourself

```bash
git --version && node --version && pnpm --version && gh --version && code --version && claude --version
```

Six version numbers means you're ready. Node should be 20 or higher — if it's 18 or lower,
run `brew upgrade node`.

Any errors: don't fight them alone. Start Claude Code and paste the error.
