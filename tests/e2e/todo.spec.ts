import { test, expect } from '@playwright/test';

test('todo application flow', async ({ page }) => {
  // Navigation vers l'application
  await page.goto('/');

  // Vérification du chargement initial
  await expect(page.getByRole('heading', { level: 1 })).toBeVisible();

  // Test d'ajout d'une tâche
  const newTodoInput = page.getByPlaceholder('Add a new todo...');
  await newTodoInput.fill('Test todo item');
  await newTodoInput.press('Enter');

  // Vérification que la tâche a été ajoutée
  await expect(page.getByText('Test todo item')).toBeVisible();

  // Test de complétion d'une tâche
  const todoItem = page.getByText('Test todo item');
  await todoItem.click();

  // Vérification des statistiques
  const stats = page.getByTestId('todo-stats');
  await expect(stats).toBeVisible();
});