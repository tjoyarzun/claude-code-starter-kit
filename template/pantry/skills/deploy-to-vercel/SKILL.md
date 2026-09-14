---
name: deploy-to-vercel
description: Put a project online with Vercel — first deploy, GitHub auto-deploy, environment variables, preview vs production, custom domains, rollback. Triggers "deploy", "publish", "make it live", "put it online", "vercel", "ship it", "go live", "rollback".
---

## What this does

Gets a project from local to a real URL, and sets up the automatic deploy-on-push loop so
this is the last time deploying is a manual task.

## Before you deploy — always

```bash
pnpm build
```

The dev server and the production build are different code paths. TypeScript errors, bad
imports, and missing dependencies routinely pass in dev and fail in build. If `build` fails,
fix it before going further — the same failure on Vercel is slower to diagnose.

Then run `/ship-check` if it hasn't been run on these changes.

## First deploy

Two routes. **Prefer the GitHub route** — it's ten more seconds now and saves every deploy
after this one.

### Route A — GitHub integration (recommended)

1. Confirm the project is pushed: `git status` clean, `git remote -v` shows origin.
2. vercel.com → **Add New** → **Project** → import the repo.
3. Accept the detected framework settings. For the Vite scaffold: build `pnpm build`, output
   `dist`. For a static site: no build command, output the root.
4. Add environment variables now if the project needs any (see below).
5. Deploy.

From then on: push to `main` → production deploy. Push any other branch, or open a PR → its
own preview URL. Nothing to run.

### Route B — CLI

```bash
pnpm dlx vercel          # first run links the project and asks setup questions
pnpm dlx vercel --prod   # deploy to production
```

Use this when they don't want the repo connected, or for a quick one-off. Note that it
deploys **local files**, including uncommitted changes — which is occasionally handy and
frequently a foot-gun.

## Environment variables

The thing that breaks most first deploys. Local env files are gitignored, so **Vercel has
never seen them.** Anything the build needs must be added in Vercel.

1. Read the project's `.env.example` to see which variables exist.
2. Vercel → project → Settings → Environment Variables. Add each one, choosing the
   environments (Production / Preview / Development).
3. Redeploy — variables are read at build time, so existing deploys don't pick them up.

CLI equivalent: `vercel env add VARIABLE_NAME`.

**Say this out loud when it comes up:** in a Vite app, only `VITE_`-prefixed variables reach
browser code, and anything that reaches browser code is **visible to anyone who opens
devtools**. If a key must stay secret, it cannot live in a frontend build at all — it needs a
server or a serverless function. Check for this before adding anything that looks like a
private key.

## Preview vs production

| | Production | Preview |
|---|---|---|
| Triggered by | Push to `main` | Push to any other branch, or a PR |
| URL | Your main domain | A unique per-deploy URL |
| Who sees it | Everyone | Anyone with the link |

This is the practical argument for branches on a solo project: a preview URL you can open on
your phone, or send to someone, without touching the live site.

## Verify the deploy — don't trust the dashboard alone

```bash
curl -sI https://<their-url> | head -n1      # expect HTTP/2 200
```

Then have them open it in a browser **and on their phone**. Check the browser console for
errors — a deploy can succeed and the page still be broken at runtime.

## Rollback

Vercel keeps every deploy. Dashboard → Deployments → find the last good one → **Promote to
Production**. Instant, no rebuild.

This is why "just push and see" is a reasonable way to work here: the undo button is real.

## Custom domain

See `pantry/cookbooks/2-custom-domain.md`.

## Common failures

| Symptom | Cause | Fix |
|---|---|---|
| Build fails on Vercel, works locally | Missing environment variables | Add them in Vercel settings, redeploy |
| Build fails on Vercel, works locally | Node version mismatch | Compare `node --version` to Vercel → Settings → Node.js Version |
| `Module not found: ./Button` | Case-sensitive filesystem on Vercel's Linux builders | Match the import's capitalization to the actual filename |
| "No GitHub repositories found" | Vercel's GitHub app lacks repo access | vercel.com → Settings → Git → configure the app |
| 404 on a route that works locally | SPA routing not rewritten to `index.html` | Confirm the framework preset, or add a `vercel.json` rewrite |
| Deployed but showing old content | Browser cache | Hard refresh; confirm the deploy timestamp in the dashboard |
| Blank page, build succeeded | Runtime JS error | Open the browser console — the real error is there |

## After a successful deploy

Update the project's row in `pantry/solutions/README.md` with the live URL and set status to
`shipped`.

## Related

- `ship-check` — run before deploying
- `pantry/cookbooks/2-custom-domain.md` — custom domains
- `git-rescue` — if the push that triggered the deploy went wrong
