import { test, expect } from '@playwright/test';

test('Todo App basic functionality', async ({ page }) => {
  // Navigate to the app
  await page.goto('http://localhost:3000');

  // Verify the todo form exists
  const input = await page.getByPlaceholder('What needs to be done?');
  await expect(input).toBeVisible();

  // Add a new todo
  await input.fill('Test todo item');
  await page.getByRole('button', { name: /add todo/i }).click();

  // Verify todo was added
  await expect(page.getByText('Test todo item')).toBeVisible();

  // Toggle todo completion
  await page.getByLabel('Mark as complete').click();
  await expect(page.getByText('Test todo item')).toHaveClass(/line-through/);

  // Verify todo stats
  await expect(page.getByText('0')).toBeVisible(); // Active count
  await expect(page.getByText('1')).toBeVisible(); // Completed count
});

test('Empty todo handling', async ({ page }) => {
  await page.goto('http://localhost:3000');

  // Try to add empty todo
  const addButton = page.getByRole('button', { name: /add todo/i });
  await addButton.click();

  // Empty todo should not be added
  await expect(page.getByText('No todos yet')).toBeVisible();
});
