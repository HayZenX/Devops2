import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react";
import path from "path";

export default defineConfig({
  plugins: [react()],
  test: {
    globals: true,
    environment: "jsdom",
    setupFiles: "./src/test/setup.ts",
    include: ["src/**/*.test.{ts,tsx}"],
    exclude: ["e2e/**", "playwright.config.*", "playwright.config.ts"],
    coverage: {
      provider: "v8",
      reporter: ["text", "json", "html"],
      exclude: ["e2e/**", "**/*.d.ts", "**/*.config.*"],
    },
    pool: "forks", // Meilleure isolation des tests
    testTimeout: 10000,
    maxConcurrency: 5,
    maxWorkers: 2,
    minWorkers: 1,
    teardownTimeout: 1000,
  },
  resolve: {
    alias: {
      "~": path.resolve(__dirname, "./src"),
    },
  },
});
