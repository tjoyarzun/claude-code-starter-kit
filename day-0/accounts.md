# Day 0 — Accounts

Three accounts. All free at the level you need.

## GitHub — github.com

Where your code lives. Every project you build gets a repo here, and it's how your code
survives a dead laptop.

- Pick a username you'd be comfortable showing an employer — it ends up in every project URL.
- **Turn on 2FA.** GitHub requires it for contributors anyway, and doing it now is easier than
  doing it under pressure later.
- Free covers unlimited public and private repos.

**Email privacy:** every commit you make records an email address, and it's visible to anyone
who can see the repo. If you'd rather not publish your real one, go to Settings → Emails →
"Keep my email addresses private" and GitHub gives you a `username@users.noreply.github.com`
address to use instead. Tell Claude if you want this — it changes one git config line.

## Vercel — vercel.com

Where your sites go live. Takes a GitHub repo and gives you a real URL with HTTPS, free.

**Sign up with the "Continue with GitHub" button**, not email. It authorizes the connection
between the two accounts in one step and avoids a common "Vercel can't find my repository"
dead end.

The free Hobby tier covers personal projects generously. It does not permit commercial use —
if a project starts making money, that's a Pro plan conversation.

## Claude — claude.ai

Claude Code needs either a **Pro** or **Max** subscription, or **API billing** set up at
console.anthropic.com.

- Pro is the normal starting point for personal projects.
- Max is worth it if you're building daily and hitting usage limits.
- API billing is pay-per-use and better if your usage is sporadic.

## Optional, later

- **A domain name** (~$12/year at Cloudflare or Namecheap) if you want `yourname.com` instead
  of `yourproject.vercel.app`. The `deploy-to-vercel` skill walks through connecting it.
- **A password manager**, if you don't have one. You're about to accumulate accounts and
  tokens.
