# `components/`

Copy-and-tweak components and patterns. Each component is self-contained — copy the folder into
your project's `src/components/` and it works.

## Available components

*(none yet — this fills up as you build)*

## Adding one

A component earns its place on the **third** reuse, not the first. Until then it's a coincidence,
not a pattern. Run `/promote-to-library` when a component qualifies; it'll do the generalizing
and write the README.

```
components/
└── <component-name>/
    ├── README.md       what it does, props, a usage example
    ├── index.tsx       the component
    └── *.css           styles, if it isn't pure Tailwind
```

## Good first candidates

Things almost every project needs eventually, in roughly the order they tend to come up:

- A page shell with header/footer and a max-width container
- A contact form with validation and a real submit handler
- A theme (dark mode) toggle that respects the system preference
- A loading skeleton and an error state you don't hate looking at
- An accessible modal (focus trap, `Esc` to close, scroll lock)
- A `useLocalStorage` hook
