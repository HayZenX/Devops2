import { test, expect } from '@playwright/test';

test('basic todo functionality', async ({ page }) => {
  await page.goto('http://localhost:3000');
  
  // Ajouter une tâche
  await page.fill('input[placeholder="Add a new todo..."]', 'Test Task');
  await page.keyboard.press('Enter');
  
  // Vérifier que la tâche est ajoutée
  await expect(page.getByText('Test Task')).toBeVisible();
});