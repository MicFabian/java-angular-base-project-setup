import { expect, test } from '@playwright/test';

test('renders the monorepo starter shell', async ({ page }) => {
  await page.goto('/');

  await expect(
    page.getByRole('heading', { name: 'Base Project' }),
  ).toBeVisible();
  await expect(page.getByText('Codex Skills + MCP')).toBeVisible();
});
