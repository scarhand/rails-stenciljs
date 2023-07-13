module ActionView
  module Helpers
    module JavaScriptHelper

      def appendDevServerClientScript()
        url = "/~dev-server"
        return javascript_tag(<<~JS.strip);
          document.addEventListener('DOMContentLoaded',_=>{
            const e = document.createElement('iframe');
            e.setAttribute('aria-hidden',true);
            e.style='display:block;width:0;height:0;border:0;visibility:hidden';
            e.title='Stencil Dev Server Connector';
            e.src='#{url}';
            document.body.appendChild(e);
          }, { once: true });
        JS
      end

      def javascript_stenciljs_tags
        no_ext = "/build/#{Rails.application.class.module_parent_name.downcase}"
        ret_val = tag.script( src: no_ext + ".js", nomodule: true ) +
                  tag.script( src: no_ext + ".esm.js", type: :module )
        ret_val += appendDevServerClientScript() if Rails.env.development?
        return ret_val
      end
    end
  end
end
