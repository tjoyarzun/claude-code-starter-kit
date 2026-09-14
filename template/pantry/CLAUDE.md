# `pantry/` — agent context

Orientation is in [README.md](README.md). This file is behavior rules for working *inside*
pantry.

## The two scaffolds

**Shape A — Web app** (`scaffold/web-app/`)

| Layer | Pick | Why |
|---|---|---|
| Build | Vite 6 + `@vitejs/plugin-react-swc` | Fast dev server, no config to babysit |
| Framework | React 18 | The default. Largest answer surface when stuck |
| Language | TypeScript, `strict: true` | Catches real bugs before they run |
| Styling | Tailwind 3 + shadcn/ui | Utility classes; shadcn components are copied in and owned |
| Remote state | TanStack Query | Loading/caching/refetching is easy to get wrong by hand |
| Lint/format | ESLint 9 flat config + Prettier | Formatting stops being a conversation |
| Test | Vitest + Testing Library | Same config as Vite; no second toolchain |
| Deploy | Vercel | Zero-config with the GitHub integration |

**Shape B — Static site** (`scaffold/static-site/`)

Plain HTML, CSS with custom properties, vanilla JS modules. No bundler, no framework, no
build step. Upgrade path is Astro when the content grows past what's comfortable to hand-edit.

## Who owns this data?

The question to ask before reaching for a state library:

- Used by one component → `useState`.
- Shared by a few components → lift it up, or Context.
- Comes from an API → TanStack Query. Not `useEffect` + `fetch` + three `useState`s.
- Belongs in the URL (filters, tabs, the current page) → put it in the URL. It's free
  shareability and free back-button support.

## Editing the scaffolds

When you change a scaffold, **verify it still works** before considering the change done:

```bash
bash pantry/tools/new-project.sh app scratch-test
cd projects/apps/scratch-test && pnpm install && pnpm build
```

Then delete the scratch project. A scaffold that doesn't build is worse than no scaffold,
because it fails at the moment someone is excited to start something.

## Adding a skill

1. `mkdir pantry/skills/<name>` and write `SKILL.md` with `name` and `description`
   frontmatter — the description is what Claude matches on, so list the trigger phrases.
2. `bash pantry/tools/link-skills.sh`
3. Restart the Claude Code session.

Keep skills concrete. A skill that says "follow best practices" does nothing; a skill that
says "run `pnpm build`, then check `dist/` is under 500 KB, then…" is worth having.

## Rules

1. **Library, not dependency.** Nothing here is imported at build time.
2. **Graduate on the 3rd reuse.** Commit messages name the project it came from.
3. **No secrets, ever.** `.env.example` only.
