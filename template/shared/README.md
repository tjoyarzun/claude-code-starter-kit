# `shared/`

Code that two projects use and that hasn't earned promotion to `library/` yet.

```
shared/
├── utils/        Pure functions — date formatting, string helpers, fetch wrappers
└── components/   UI used by more than one project
```

## `shared/components/` vs `library/components/`

Same kind of file, different stage — and the stage is the whole point:

| | `shared/` | `library/components/` |
|---|---|---|
| Reuse count | 2 | 3 or more |
| State | Still changing shape | Stable, generalized, documented |
| Has a README? | No | Required |
| How it got there | You copied it | `/promote-to-library` |

Two uses is a coincidence; three is a pattern. `shared/` is where the second copy waits while
you find out which it is. If something sits here through a third project without changing,
promote it. If you keep rewriting it, it wasn't ready.

**Projects copy from here, they don't import from here at build time** — same rule as
`library/`. Keeping projects self-contained means any one of them can be moved, zipped, or
handed to someone else without dragging the workspace along.
