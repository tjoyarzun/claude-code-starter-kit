# Cookbook 0 — Your first web app, start to live

*Shape A: Vite + React + TypeScript + Tailwind, deployed to Vercel. About 20 minutes.*

The fast path is `/new-project` in Claude Code, which does all of this and asks better
questions. This is the manual version, so you know what the skill is doing.

## 1. Create it

```bash
cd ~/dev
bash pantry/tools/new-project.sh app my-app
cd projects/apps/my-app
pnpm install
```

`pnpm install` reads `package.json` and downloads dependencies into `node_modules/`. First run
takes a minute; later ones are nearly instant because pnpm caches globally.

## 2. Run it

```bash
pnpm dev
```

Open http://localhost:5173. Edit `src/App.tsx`, save, and watch the browser update without a
reload — that's hot module replacement, and it's the main reason the dev server exists.

**Working:** you see "Hello" in the browser and edits appear instantly.

`Ctrl+C` stops the server. It only runs on your machine — nobody else can reach that URL.

## 3. Commit

```bash
git add -A
git commit -m "initial commit"
```

`new-project.sh` already ran `git init` and staged the files.

## 4. Put it on GitHub

```bash
gh repo create my-app --private --source=. --push
```

`--source=.` means "this folder," `--push` sends the commits up. Swap `--private` for
`--public` if you want it visible. You can flip that later in repo settings.

**Working:** `gh repo view --web` opens your code on github.com.

## 5. Deploy

```bash
pnpm build          # always build locally first — it catches what dev hides
pnpm dlx vercel     # first run: link the project, accept the detected settings
pnpm dlx vercel --prod
```

Vercel detects Vite and fills in the build command and output directory. Accept the defaults.

**Working:** it prints a `https://my-app-….vercel.app` URL and that URL loads your app.

Better still, connect the GitHub repo at vercel.com → Add New → Project. After that, every
push to `main` deploys production automatically and every branch gets a preview URL — you
stop running deploy commands entirely.

## 6. Close the loop

```bash
# change a heading in src/App.tsx
git add -A && git commit -m "update hero copy" && git push
```

Watch the Vercel dashboard rebuild. That's the loop you'll use forever: **edit → commit →
push → live**.

## 7. Record it

Add a row in `pantry/solutions/README.md` with the path, repo, live URL, and status.

---

## Traps

| Symptom | Cause | Fix |
|---|---|---|
| `pnpm: command not found` | Corepack never activated pnpm | `corepack enable && corepack prepare pnpm@latest --activate` |
| Vite won't start | Node older than 20 | `node --version`, then upgrade |
| Port 5173 in use | Another dev server is running | `pnpm dev -- --port 5174` |
| Build works locally, fails on Vercel | Missing environment variables (your local env file is gitignored, so Vercel never saw it), or case-sensitive imports | Add the variables in Vercel → Settings → Environment Variables; check import capitalization |
| Tailwind classes do nothing | The file isn't in `content` in `tailwind.config.ts` | Add its glob and restart the dev server |

## Next

- `pnpm dlx shadcn@latest add button card` — add real components
- `/ship-check` before each deploy
- Cookbook 2 if you want a custom domain
