---
name: git-rescue
description: Get out of a git mess safely — undo a commit, unstage, discard changes, fix a merge conflict, recover a deleted branch, remove a committed secret, fix a wrong-branch commit. Triggers "git broke", "undo", "revert", "merge conflict", "I messed up git", "wrong branch", "lost my work", "committed a secret", "rejected push".
---

## What this does

Diagnoses a git problem and fixes it **without losing work**. Git almost never actually
destroys anything — but the commands that recover it are unmemorable, and the ones that *do*
destroy things look similar. This skill keeps those apart.

## Rule 0 — Look before touching

Always, before any fix:

```bash
git status
git log --oneline -10
git branch -a
```

Tell them in plain language what state they're in. Most of the panic is not knowing.

## Rule 1 — Take a safety net first

Before anything that rewrites history or discards changes:

```bash
git stash list                      # is there already something stashed?
git branch backup-$(date +%s)       # a bookmark to the current commit, free and instant
```

Mention it. "I'm making a backup branch first" is reassuring and true.

## Rule 2 — Never rewrite pushed history without asking

`git reset --hard`, `git commit --amend`, and `git push --force` on a branch that other people
(or another machine) have pulled will cause a mess. On a solo project it's usually fine — but
**say so and get a yes** rather than assuming.

---

## The catalog

### "I want to undo my last commit but keep the changes"

```bash
git reset --soft HEAD~1
```

Commit is gone, files untouched and still staged. The usual fix for a premature or
badly-messaged commit.

### "I want to change the last commit's message"

```bash
git commit --amend -m "better message"
```

If it's already pushed, this needs a force-push. Ask first.

### "I staged files I didn't mean to"

```bash
git restore --staged <file>     # unstage one
git reset                       # unstage everything, keep changes
```

### "I want to throw away my changes to a file"

```bash
git diff <file>                 # SHOW THEM FIRST — this is unrecoverable
git restore <file>
```

**Never run this without showing the diff first.** Uncommitted changes are the one thing git
genuinely cannot get back.

### "I committed to the wrong branch"

```bash
git log --oneline -3            # note the commit hash
git reset --soft HEAD~1         # undo the commit, keep the changes staged
git stash
git switch correct-branch
git stash pop
git commit -m "original message"
```

### "My push was rejected"

The remote has commits you don't:

```bash
git pull                        # merges the remote's work in
# resolve conflicts if any, then:
git push
```

If it says "refusing to merge unrelated histories," the local repo and the remote were started
separately — stop and diagnose rather than passing the flag that forces it.

### "I have a merge conflict"

1. `git status` — lists conflicted files.
2. Open each. Git marks both versions:
   ```
   <<<<<<< HEAD
   your version
   =======
   their version
   >>>>>>> branch-name
   ```
3. Edit to what it should actually be. **Delete all three marker lines.** Often the answer is
   a combination, not one side.
4. `git add <file>` for each resolved file.
5. `git commit` — git pre-fills the message.

To abandon the merge entirely and go back: `git merge --abort`.

Read the conflicting regions to them and explain what each side did before editing. Resolving
a conflict you don't understand is how work silently disappears.

### "I deleted a branch / lost commits"

```bash
git reflog
```

Every commit HEAD has pointed at, for ~90 days, including "lost" ones. Find the hash, then:

```bash
git branch recovered <hash>
```

This recovers almost everything people think they destroyed. Reach for it before concluding
work is gone.

### "I committed a secret"

**Treat the key as compromised the moment it reached the remote** — private repo, one minute,
doesn't matter. Order of operations:

1. **Rotate the key first.** Revoke it at the provider and issue a new one. This is the step
   that actually protects them; everything below is cleanup.
2. If it is **not yet pushed** — remove it from the last commit:
   ```bash
   # delete the secret from the file first, then:
   git add <file>
   git commit --amend --no-edit
   ```
3. If it **is pushed** — the value is in the history and on GitHub's servers. Rewriting
   history (`git filter-repo`, or the BFG) is possible but fiddly, and for a young personal
   repo the honest answer is often: rotate the key, delete the repo, and push a clean one.
   Lay out both options and let them choose.
4. Prevent the repeat: confirm the filename is in `.gitignore`, and that an `.example`
   variant (with values removed) is what's tracked.

### "I want to undo a commit that's already pushed"

```bash
git revert <hash>
```

Creates a *new* commit that undoes the old one. History stays intact, nothing to force-push.
This is the safe option and usually the right one.

---

## What to say afterward

One or two sentences on what happened and how to avoid it, then stop. The goal is they feel
less afraid of git, not more careful around it.

Worth repeating when it fits: **commit early and often.** Most git disasters are really "I had
four hours of uncommitted work." Small commits make every one of these fixes trivial.

## Related

- `docs/concepts.md` — what commits, branches, and remotes actually are
- `ship-check` — catches secrets *before* they're committed
