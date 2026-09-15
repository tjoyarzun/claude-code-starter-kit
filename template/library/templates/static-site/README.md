# Static Site Scaffold (Shape B)

Plain HTML, CSS, and JavaScript. No bundler, no framework, no build step — files a browser
opens directly.

## Start a project from it

```bash
bash library/tools/new-project.sh site <slug>
cd projects/sites/<slug>
npx serve .              # http://localhost:3000
```

You *can* double-click `index.html`, but JavaScript modules are blocked over `file://`, so
`js/main.js` won't run. Use `npx serve .` — it also behaves like production.

## What's here

| File | What it does |
|---|---|
| `index.html` | Structure, content, and the meta tags that control tab title and link previews |
| `css/reset.css` | Levels out browser default styles so you start from a known state |
| `css/tokens.css` | **Your design system** — colors, spacing, type scale, radius, shadows, as CSS variables |
| `css/main.css` | Layout and component styles, built from those variables |
| `js/main.js` | A JS module. Currently just keeps the footer year current |
| `assets/` | Images, icons, fonts. Placeholder favicon included |

## Change the look in one place

Edit `css/tokens.css` first. Change `--color-accent` and `--font-sans` there and the whole
site follows, because nothing else hardcodes a color or a font.

Dark mode is already handled — the tokens re-declare themselves under
`@media (prefers-color-scheme: dark)`, so the site respects the visitor's system setting with
no toggle and no JavaScript.

## Before you deploy

- Replace `<title>`, the description meta, and the Open Graph tags
- Replace `assets/favicon.svg`
- Replace "Your Name" in the footer
- Check it at 375px wide — nothing should scroll sideways

Then run `/ship-check`.

## Deploying

```bash
pnpm dlx vercel --prod
```

No build configuration — the files are served as they are. Netlify, Cloudflare Pages, and
GitHub Pages all work the same way.

## Growing out of it

Around 6–8 pages, repeating the header and footer by hand starts to hurt. That's the signal
to move to Astro, which keeps your HTML and CSS, adds components and content collections, and
still ships zero JavaScript by default:

```bash
pnpm create astro@latest .
```

Moving to React (Shape A) is the other path — but only if the site needs real interactivity,
not just to avoid copy-pasting a nav.
