import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import App from "./App";

// A sample test so `pnpm test` does something real on day one.
// Delete it once you have tests of your own.
describe("App", () => {
  it("renders a heading", () => {
    render(<App />);
    expect(screen.getByRole("heading", { level: 1 })).toBeInTheDocument();
  });
});
