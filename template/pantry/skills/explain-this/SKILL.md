---
name: explain-this
description: Teaching mode — explain a file, an error, a command, a concept, or a chunk of code at the depth asked for, grounded in the actual code rather than generalities. Triggers "explain this", "what does this do", "how does this work", "what is", "why does", "walk me through", "I don't understand", "teach me".
---

## What this does

Explains something in this workspace — a file, an error, a command, a library, a decision —
at the right depth, using the code that's actually here.

The goal is that they could explain it to someone else afterward. Not that they feel informed.

## Read before explaining

**Always open the actual file.** An explanation of what `vite.config.ts` usually contains is
worth nothing next to an explanation of what *theirs* contains. Cite `file:line` so they can
follow along.

For errors: read the full message including the stack trace, then find the file and line it
points at and read the surrounding code.

## Pick the depth

Match the question, and say which level you're giving so they can ask for a different one.

| They asked | Give them |
|---|---|
| "What is this file for?" | Purpose, its role in the project, when they'd touch it. A few sentences. |
| "How does this work?" | The mechanism. What calls what, in what order, with what data. |
| "Why is it done this way?" | The tradeoff. What the alternatives were and what this buys. |
| "What is X?" (concept) | Plain definition, then where X shows up in *their* code. |
| An error | What it means in English → what caused it → the fix → how to recognize it next time. |

Default to the middle. If they say "shorter" or "more detail," recalibrate and stay there for
the rest of the session.

## How to explain well

**Start with the thing it's for.** "This file is how Vite knows where your source code lives
and what to do with it" before any line-by-line walk.

**Use their code, not a textbook example.** `src/App.tsx:12` beats an invented snippet — the
invented one is always subtly different and that difference is where confusion lives.

**Name things precisely.** "The `queryClient` on line 7" not "that variable up there." The
vocabulary is half of what they're learning.

**One analogy, maximum, and only if it earns its place.** Analogies leak; a wrong mental model
is more expensive than no mental model.

**Say what you don't know.** "I'd have to check the docs for how that flag behaves" is a
better answer than a confident guess. If it matters, go check.

**Show the boundary.** Which part is React, which is Vite, which is TypeScript, which is the
project's own code? Beginners routinely think a framework feature is a language feature, and
it makes everything confusing.

## For errors specifically

1. **Quote the actual error line.** Not a paraphrase.
2. **Translate it.** "`Cannot read properties of undefined (reading 'map')` means something
   tried to call `.map()` on a value that doesn't exist yet."
3. **Find where.** Open the file and line, show the code.
4. **Explain the cause.** Usually: data that hasn't arrived yet, a typo'd name, or a wrong
   assumption about a shape.
5. **Fix it** — and say why the fix works.
6. **Generalize once.** "The pattern here is: anything that comes from a fetch can be
   undefined on the first render."

## For "should I use X?"

Answer directly with a recommendation. Don't produce a balanced survey — they're asking
because they want a decision.

Structure: what it does → whether it fits *this* project → what it costs (dependency,
concept, lock-in) → the recommendation → what to use instead if no.

Default bias for this workspace: **fewer dependencies.** Most of what libraries are added for
is twenty lines of code that never breaks.

## Follow through

End with: "Want me to go deeper on any part of that?" — and mean it. The follow-up question is
usually where the actual confusion was.

If it was genuinely non-obvious and likely to recur, offer to write it into `agent-docs/`.

## Related

- `docs/concepts.md` — the vocabulary, defined
- `docs/how-claude-code-works.md` — how to work with Claude Code itself
