import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';
import path from 'path';
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  import { defineConfig } from 'vitest/config';
  import react from '@vitejs/plugin-react';
  import path from 'path';

  export default defineConfig({
    plugins: [react()],
    test: {
      globals: true,
      environment: 'jsdom',
      setupFiles: './src/test/setup.ts',
      // Exclude end-to-end tests from Vitest so only unit tests run
      import { defineConfig } from 'vitest/config'
      import react from '@vitejs/plugin-react'
      import path from 'path'

      export default defineConfig({
        plugins: [react()],
        test: {
          globals: true,
          environment: 'jsdom',
          setupFiles: './src/test/setup.ts',
          // Exclude end-to-end tests from Vitest so only unit tests run
          exclude: ['**/tests/e2e/**', '**/e2e/**'],
          coverage: {
            provider: 'v8',
            reporter: ['text', 'json', 'html'],
          },
        },
        resolve: {
          alias: {
            '~': path.resolve(__dirname, './src'),
          },
        },
      })
