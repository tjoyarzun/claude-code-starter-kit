# Cookbook 1 — Your first static site

*Shape B: HTML, CSS, and vanilla JS. No build step. About 10 minutes.*

## When this is the right call

More often than people assume. Choose Shape B when:

- The content doesn't change based on who's looking at it
- There's no login, no database, no live data
- It's a personal site, a landing page, an event page, a résumé, a portfolio

You get: instant loads, nothing to update, no dependencies, nothing that can break in two
years. Moving to React later is easy. Starting in React "just in case" is how a weekend
project becomes a chore.

## 1. Create it

```bash
cd ~/dev
bash pantry/tools/new-project.sh site my-site
cd projects/sites/my-site
```

## 2. Look at it

```bash
npx serve .
```

Open the printed URL (usually http://localhost:3000). You can also just double-click
`index.html` — but a local server behaves more like production, so prefer `serve`.

## 3. What you've got

```
index.html        Structure and content
css/reset.css     Levels out browser default styles
css/tokens.css    Your design system — colors, spacing, type scale, in CSS variables
css/main.css      Layout and component styles
js/main.js        A JS module, loaded with type="module"
assets/           Images, icons, fonts
```

**Edit `css/tokens.css` first.** Change `--color-accent` and `--font-sans` there and the whole
site changes at once. That's the entire point of a token file — one place to change, not
forty. Dark mode is already wired via `prefers-color-scheme`.

## 4. Make it yours

In `index.html`, replace: the `<title>`, the `description` meta, the Open Graph tags (those
control how the link looks when shared), the nav labels, and the hero text.

Ask Claude for structure you don't want to hand-write: "add a projects section with three
cards that stack on mobile."

## 5. Ship it

```bash
git add -A && git commit -m "initial site"
gh repo create my-site --public --source=. --push
pnpm dlx vercel --prod
```

No build configuration — Vercel serves the files as-is.

**Working:** the `.vercel.app` URL loads your site, styled.

## 6. Check it on a phone

Open the URL on your actual phone. Desktop-only checking is how sites ship broken on mobile.
Also run Lighthouse (Chrome devtools → Lighthouse) — a static site should score near 100, and
if it doesn't, something's wrong worth knowing about.

---

## Traps

| Symptom | Cause | Fix |
|---|---|---|
| CSS changes don't appear | Browser cached the stylesheet | Hard refresh: `Cmd+Shift+R` / `Ctrl+Shift+R` |
| `js/main.js` doesn't run | Opened via `file://`, which blocks modules | Use `npx serve .` |
| Images don't load after deploy | Case-sensitive paths on Linux | `Photo.JPG` ≠ `photo.jpg` — match exactly |
| Fonts look different live | A local font isn't installed for visitors | Use a webfont or a system font stack |

## Upgrading to Astro

When hand-editing repeated HTML starts to grate (usually around 6–8 pages):

```bash
pnpm create astro@latest .
```

Astro keeps your HTML and CSS, adds components and content collections, and still ships zero
JavaScript by default.
