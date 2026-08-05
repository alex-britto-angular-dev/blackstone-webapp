import { test, expect } from '@playwright/test';

test('Login Success', async ({ page }) => {

  await page.goto('http://localhost:4200/login');

  await page.fill('#username', 'admin');

  await page.fill('#password', '123');

  await page.click('#loginBtn');

  await expect(page.getByText('Login Successful')).toBeVisible();

});