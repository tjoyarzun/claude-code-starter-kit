---
name: ship-check
description: Pre-deploy gate — typecheck, lint, build, secret scan, accessibility, performance, mobile, and metadata checks with a fix-now vs fix-later verdict. Triggers "ship check", "ready to deploy", "is this ready", "check before deploy", "review before shipping", "audit this".
---

## What this does

Runs the checks that catch the things that actually break personal projects, and gives a clear
verdict: **ship it**, or **fix these first**.

Not a code review. It answers one question — is this safe to put in front of people?

## How to report

Findings use two buckets, and only two. More granularity than this gets ignored.

| Bucket | Meaning |
|---|---|
| **BLOCKER** | Don't deploy. Broken build, exposed secret, unusable on mobile, broken primary action. |
| **LATER** | Real, worth fixing, doesn't stop this deploy. Note it and move on. |

If there are no blockers, say **"Ship it"** plainly. A gate that always finds something
becomes a gate people stop running.

---

## 1. It has to build

```bash
pnpm typecheck    # if the script exists
pnpm lint
pnpm build
```

Any failure is a **BLOCKER**. Report the actual error, not "build failed."

For a static site there's no build — check instead that every `<link>`, `<script>`, and
`<img>` path resolves to a file that exists.

## 2. No secrets are shipping

```bash
git status --porcelain
git check-ignore -q .env && echo "env ignored: good" || echo "WARNING: env file is tracked"
```

Then grep the source that ships (`src/`, or the site root) for long random-looking strings and
anything matching `sk-`, `ghp_`, `AKIA`, `AIza`, `-----BEGIN`, or `api_key =`.

Two separate **BLOCKER** conditions:

- A secret in a file git tracks.
- A real secret in **any frontend code at all**, including behind a `VITE_` variable. Frontend
  bundles are public. If a key is in one, it's published. Say so directly.

## 3. Accessibility — the four that matter

Not a full WCAG audit. These four catch most of the real damage:

1. **Images have `alt`.** Decorative images get `alt=""`; meaningful ones get a description.
2. **Contrast.** Body text ≥ 4.5:1 against its background. Light gray on white is the usual
   offender.
3. **Keyboard.** Every interactive thing is reachable by `Tab` and has a visible focus ring.
   If the CSS removes `outline`, something must replace it. Clickable `<div>`s that should be
   `<button>`s belong here too.
4. **Headings are a real outline.** One `<h1>`, no skipped levels. Headings are for structure,
   not font size.

Unusable-by-keyboard on the primary action is a **BLOCKER**. The rest are usually **LATER**.

## 4. Mobile

Over half of visitors. Check:

- A viewport meta tag exists.
- Nothing scrolls horizontally at 375px wide.
- Tap targets are roughly 44px or larger.
- Text is readable without zooming (16px body minimum).

Horizontal scroll or an unusable nav on mobile is a **BLOCKER** — it's the most common way a
personal site is broken for most of the people who see it.

## 5. Performance sanity

```bash
du -sh dist/ 2>/dev/null
find . -path ./node_modules -prune -o \( -name '*.jpg' -o -name '*.png' \) -size +500k -print
```

- Any image over 500 KB → **LATER** (resize; a 4 MB phone photo as a hero is the classic).
- `dist/` over ~2 MB for a small project → **LATER**, worth asking what's in it.
- Fonts: more than two families or four weights → **LATER**.

## 6. Metadata — does the link look right when shared?

Check `index.html` (or the head component):

- `<title>` that isn't "Vite + React" or "Site Title"
- `<meta name="description">`
- Open Graph tags: `og:title`, `og:description`, `og:image`
- A favicon that isn't the Vite logo

Placeholder title or description on something public → **BLOCKER**, because it's embarrassing
and takes ten seconds. The rest are **LATER**.

## 7. Content

Search the shipping files for: `lorem ipsum`, `TODO`, `FIXME`, `Hello`, `Your Name`,
`example.com`, `Replace this`.

Placeholder text on a public page → **BLOCKER**.

## 8. Does the main thing work?

The checks above are all mechanical. This one isn't: **what is this page for, and does that
work?** Contact form actually submits. Links go somewhere real. The demo doesn't throw in the
console.

Ask them to click through the primary flow while the dev server is running. Broken primary
action → **BLOCKER**.

---

## The verdict

```
SHIP IT ✓
  or
BLOCKERS (2)
  1. <what> — <where> — <fix>
  2. …
LATER (3)
  1. …
```

Offer to fix the blockers now. Offer to write the LATER items into the project's README as a
short list, so they exist somewhere other than a chat that's about to be cleared.

## Related

- `deploy-to-vercel` — the next step once it's clean
- `git-rescue` — if the secret scan finds something already committed
