# `shared/`

Utilities and components used by more than one project, but not polished enough (or too
personal) to belong in `pantry/`.

```
shared/
├── utils/        Pure functions — date formatting, string helpers, fetch wrappers
└── components/   UI shared across projects
```

**Projects copy from here, they don't import from here at build time.** Keeping projects
self-contained means any one of them can be moved, zipped, or handed to someone else without
dragging the workspace along.

When something here gets used a third time and has stabilized, graduate it to
`pantry/snacks/` with the `/graduate-to-pantry` skill.
