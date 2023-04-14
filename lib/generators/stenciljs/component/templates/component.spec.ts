import { newSpecPage } from '@stencil/core/testing';
import { <%= class_name %> } from '../<%= file_name %>';

describe('<%= file_name %>', () => {
  it('renders', async () => {
    const page = await newSpecPage({
      components: [<%= class_name %>],
      html: `<<%= file_name %>></<%= file_name %>>`,
    });
    expect(page.root).toEqualHtml(`
      <<%= file_name %>>
        <mock:shadow-root>
          <slot></slot>
        </mock:shadow-root>
      </<%= file_name %>>
    `);
  });
});

