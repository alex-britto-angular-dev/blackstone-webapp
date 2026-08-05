import { test, expect } from '@playwright/test';

test('Login API returns 200', async ({ page }) => {

  page.on('request', req => {
    console.log('REQUEST:', req.method(), req.url());
  });

  page.on('response', res => {
    console.log('RESPONSE:', res.status(), res.url());
  });

  await page.goto('http://localhost:4200/login');

  await page.fill('#username', 'admin');
  await page.fill('#password', '123');

  const responsePromise = page.waitForResponse(response =>
    response.url().includes('/api/Auth/login') &&
    response.request().method() === 'POST'
  );

  await page.click('#loginBtn');

  const response = await responsePromise;

  expect(response.status()).toBe(200);
});