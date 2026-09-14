import react from "@vitejs/plugin-react-swc";
import path from "path";
// Imported from "vitest/config", not "vite" — that's what makes the `test` block below
// type-check. Using "vite" here is a common and confusing error.
import { defineConfig } from "vitest/config";

export default defineConfig({
  plugins: [react()],
  resolve: {
    // Lets you write `import { cn } from "@/lib/utils"` instead of "../../lib/utils".
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  test: {
    environment: "happy-dom",
    globals: true,
    setupFiles: ["./src/test/setup.ts"],
  },
});
