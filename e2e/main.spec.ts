import { test, expect } from '@playwright/test';

test('todo app basic functionality', async ({ page }) => {
  // Aller à la page d'accueil
  await page.goto('/');

  // Vérifier que le formulaire d'ajout est présent
  const addTodoForm = page.getByRole('textbox');
  await expect(addTodoForm).toBeVisible();

  // Ajouter une nouvelle tâche
  await addTodoForm.fill('Test todo item');
  await addTodoForm.press('Enter');

  // Vérifier que la tâche est ajoutée
  await expect(page.getByText('Test todo item')).toBeVisible();
});