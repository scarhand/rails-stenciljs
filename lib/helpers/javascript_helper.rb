module ActionView
  module Helpers
    module JavaScriptHelper
      def javascript_stenciljs_tags
        tag.script( src: "/build/#{Rails.application.class.module_parent_name.downcase}.js", nomodule: true ) +
          tag.script( src: "/build/#{Rails.application.class.module_parent_name.downcase}.esm.js", type: :module )
      end
    end
  end
end