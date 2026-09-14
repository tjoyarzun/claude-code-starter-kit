# pnpm refuses to run dependency build scripts by default

*Found while verifying the web-app scaffold, September 2026. pnpm 11.1.3.*

**What happened:** `pnpm install` finished, then `pnpm build` failed immediately with:

```
[ERR_PNPM_IGNORED_BUILDS] Ignored build scripts: @swc/core, esbuild
Run "pnpm approve-builds" to pick which dependencies should be allowed to run scripts.
```

**Why:** since v10, pnpm does not run dependency `postinstall` scripts unless you allow each
package explicitly. It's a supply-chain defense — a malicious package can't run code on your
machine just because you installed it. `@swc/core` and `esbuild` both compile native binaries
in `postinstall`, so Vite is broken until they're allowed.

**The trap:** the setting has moved twice. `pnpm.onlyBuiltDependencies` in `package.json` is
**no longer read at all** in pnpm 11 — it's silently ignored except for one warning line. The
current home is `allowBuilds` in `pnpm-workspace.yaml`, even for a single project with no
workspace:

```yaml
allowBuilds:
  "@swc/core": true
  esbuild: true
```

The scaffold ships this file, so new projects don't hit it.

**What to do next time:** when a package needs a build script, `pnpm approve-builds` adds it
here interactively. Look at what the package is before approving — that prompt is the defense
working, not an obstacle.

**Related:** the same verification run found that Vitest 2 bundles Vite 5's types, which
conflict with Vite 6 and break `tsc --noEmit` with a wall of "not assignable" errors. Vitest 3
fixes it. If you ever see type errors naming two different `node_modules/.pnpm/vite@…` paths,
that's the shape of the problem: two copies of a library's types in one project.
