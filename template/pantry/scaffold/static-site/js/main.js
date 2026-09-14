// Loaded as a module (type="module" in index.html), so `import` works and nothing
// leaks into the global scope. Note: modules don't run from file:// — use `npx serve .`.

// Keep the copyright year current without touching the HTML every January.
const yearEl = document.getElementById("year");
if (yearEl) yearEl.textContent = String(new Date().getFullYear());
