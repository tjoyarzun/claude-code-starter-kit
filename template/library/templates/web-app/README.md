# Web App Scaffold (Shape A)

Vite 6 + React 18 + TypeScript (strict) + Tailwind 3. Ready for shadcn/ui.

## Start a project from it

```bash
bash library/tools/new-project.sh app <slug>
cd projects/apps/<slug>
pnpm install
pnpm dev                 # http://localhost:5173
```

## What's here

| File | What it does |
|---|---|
| `vite.config.ts` | Dev server and build config. Sets the `@/` → `src/` alias and the Vitest environment |
| `tsconfig.json` | TypeScript in strict mode |
| `tailwind.config.ts` | Tailwind, with CSS-variable colors so shadcn/ui components work unmodified |
| `postcss.config.js` | Runs Tailwind + autoprefixer. **Without this, Tailwind silently does nothing** |
| `eslint.config.js` | ESLint 9 flat config — TypeScript + React Hooks rules |
| `.prettierrc` | Formatting, with automatic Tailwind class sorting |
| `src/main.tsx` | Entry point. Mounts React and provides TanStack Query |
| `src/App.tsx` | Your root component — start here |
| `src/index.css` | Tailwind directives and the light/dark design tokens |
| `src/lib/utils.ts` | `cn()` — merges Tailwind classes without conflicts |
| `src/App.test.tsx` | A sample test so `pnpm test` does something real |
| `public/favicon.svg` | Placeholder favicon — replace it |

## Commands

```bash
pnpm dev          # dev server with hot reload
pnpm build        # typecheck + production build → dist/
pnpm preview      # serve the production build locally
pnpm typecheck    # types only
pnpm lint         # ESLint
pnpm format       # Prettier, writes in place
pnpm test         # Vitest, one run
pnpm test:watch   # Vitest, watching
```

## Adding UI components

shadcn/ui components are copied into your project — you own the files and can edit them.

```bash
pnpm dlx shadcn@latest init      # first time only
pnpm dlx shadcn@latest add button card dialog
```

They land in `src/components/ui/` and work with the tokens already in `src/index.css`.

## Fetching data

TanStack Query is already wired up in `main.tsx`:

```tsx
import { useQuery } from "@tanstack/react-query";

const { data, isLoading, error } = useQuery({
  queryKey: ["posts"],
  queryFn: () => fetch("/api/posts").then((r) => r.json()),
});
```

Use it instead of `useEffect` + `fetch` + three `useState`s. Loading, caching, refetching, and
race conditions are the parts that are easy to get subtly wrong.

## Before you deploy

Run `/ship-check`. At minimum: replace the `<title>` and meta description in `index.html`,
replace the favicon, and confirm `pnpm build` passes.
