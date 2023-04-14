import { newE2EPage } from '@stencil/core/testing';

describe('<%= file_name %>', () => {
  it('renders', async () => {
    const page = await newE2EPage();
    await page.setContent('<<%= file_name %>></<%= file_name %>>');

    const element = await page.find('<%= file_name %>');
    expect(element).toHaveClass('hydrated');
  });
});
