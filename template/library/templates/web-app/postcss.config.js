// Tailwind runs as a PostCSS plugin. Without this file Tailwind silently does nothing —
// your classes are in the HTML, no styles appear, and nothing errors.
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
