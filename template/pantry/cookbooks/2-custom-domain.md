# Cookbook 2 — Point a custom domain at a Vercel project

*About 15 minutes of work, plus up to an hour of waiting for DNS.*

## 1. Buy the domain

Cloudflare Registrar (at-cost, no upsells) or Namecheap. Roughly $10–15/year for a `.com`.
Avoid the registrars that sell a cheap first year and renew at 5×.

You can also buy through Vercel — more expensive, but it skips every step below.

## 2. Add it to the project

vercel.com → your project → Settings → Domains → add `yourdomain.com`.

Vercel then shows you the DNS records it needs. Add **both** the apex and the `www` variant;
Vercel redirects one to the other automatically.

## 3. Add the DNS records at your registrar

Vercel shows the exact values — use those, not these, if they differ:

| Type | Name | Value |
|---|---|---|
| `A` | `@` | `76.76.21.21` |
| `CNAME` | `www` | `cname.vercel-dns.com` |

`@` means the bare domain. If your registrar offers "Nameservers" instead, pointing
nameservers at Vercel also works and is less fiddly — but then Vercel manages all your DNS,
including email records, so don't do that if the domain already handles mail.

## 4. Wait

DNS propagation is usually minutes, occasionally hours. Vercel's dashboard shows "Valid
Configuration" when it's live, and issues an HTTPS certificate automatically.

Check from the terminal:

```bash
dig yourdomain.com +short        # should return the A record value
curl -sI https://yourdomain.com  # should return HTTP/2 200
```

## 5. Set the primary

In Vercel → Domains, mark one as primary (usually the bare `yourdomain.com`). The other
redirects to it. Pick one and keep it — search engines treat `www.x.com` and `x.com` as
different sites, and splitting between them costs you.

---

## Traps

| Symptom | Cause | Fix |
|---|---|---|
| "Invalid Configuration" after an hour | Record typo, or the registrar appended the domain to the name field | Check the `Name` field — some registrars want `@`, some want blank, some want the full domain |
| Works on `www`, not the bare domain | Missing the apex `A` record | Add it |
| Certificate error | Cert issues after DNS resolves | Wait; if it's still failing after an hour, remove and re-add the domain in Vercel |
| Email stopped working | Nameservers moved to Vercel, dropping MX records | Re-add your MX records, or move DNS back and use A/CNAME records instead |

## Notes

- HTTPS is automatic and free. Never pay for a certificate for this.
- Subdomains work the same way: `blog.yourdomain.com` as a `CNAME` to `cname.vercel-dns.com`,
  added to whichever project should serve it.
- Domains are per-project, so a second site needs its own (or a subdomain).
