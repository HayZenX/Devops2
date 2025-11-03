import { test, expect } from '@playwright/test';

test('home page has correct title', async ({ page }) => {
  await page.goto('/');
  const title = await page.title();
  expect(title).toBeTruthy();
});

test('can add todo', async ({ page }) => {
  await page.goto('/');
  await page.fill('input[type="text"]', 'Test todo');
  await page.click('button[type="submit"]');
  await expect(page.locator('text=Test todo')).toBeVisible();
});