# Day 0 — Windows pre-flight

You only need this file if you want to install things yourself before handing off to Claude,
or if the one-liner in the README failed. Claude covers the same ground in Phase 1.

## The short version of why WSL

Web development tooling is built and tested on Linux and macOS. On Windows you can fight that
forever, or you can run a real Ubuntu inside Windows — that's WSL2 (Windows Subsystem for
Linux). It's a first-class Microsoft feature, not a hack, and it's how most professional web
developers work on Windows. Your files, your browser, and VS Code all still work normally.

## 1. Install WSL2

Open **PowerShell as Administrator** (right-click Start → "Terminal (Admin)"):

```powershell
wsl --install
```

Restart when it asks. After restart, an **Ubuntu** window opens and asks you to create a
username and password. Pick something simple — this password is only for `sudo` inside
Ubuntu, and it won't echo characters as you type. That's normal, keep typing.

From now on, **everything happens in the Ubuntu window**, not PowerShell. Find it in the
Start menu as "Ubuntu."

## 2. Base packages

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl build-essential
```

## 3. Node via nvm

Do **not** use `apt install nodejs` — Ubuntu ships a very old version and it will break Vite
later in a confusing way. Use nvm, the Node version manager:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
exec $SHELL
nvm install --lts
nvm use --lts
node --version
```

Then pnpm:

```bash
corepack enable && corepack prepare pnpm@latest --activate
```

## 4. GitHub CLI

```bash
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
  && sudo mkdir -p -m 755 /etc/apt/keyrings \
  && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
  && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo apt update && sudo apt install gh -y
```

(That wall of text is GitHub's official install — it adds their package signing key so apt
trusts the download.)

## 5. VS Code

Install VS Code **on the Windows side** from code.visualstudio.com — not inside Ubuntu. Then
install the **WSL** extension (search "WSL" in the Extensions panel). That extension is what
lets Windows-side VS Code edit Linux-side files properly.

Test it from Ubuntu:

```bash
cd ~ && code .
```

VS Code should open with a green `WSL: Ubuntu` badge in the bottom-left corner. That badge is
how you know you're editing the right filesystem.

## 6. Claude Code

```bash
curl -fsSL https://claude.ai/install.sh | bash
claude
```

## 7. Check yourself

```bash
git --version && node --version && pnpm --version && gh --version && code --version && claude --version
```

## The one rule that matters on Windows

**Keep your projects inside the Linux filesystem** — paths starting with `/home/you/` or
`~/`. Never put a project in `/mnt/c/Users/...`. Crossing the Windows/Linux filesystem
boundary makes `pnpm install` 10–50× slower and breaks file-watching in the dev server, which
shows up as "why doesn't the page reload when I save?"

To get at your files from Windows Explorer, type `\\wsl$` in the address bar — they're all
there.
