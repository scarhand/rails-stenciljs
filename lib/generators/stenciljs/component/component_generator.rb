module Stenciljs
  class ComponentGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    RESERVED_COMPONENT_NAMES = %w(
      annotation-xml
      color-profile
      font-face
      font-face-src
      font-face-uri
      font-face-format
      font-face-name
      missing-glyph
    ).freeze

    def create_component
      validate_component_name!

      template "component.scss",    "app/javascript/components/#{file_name}/#{file_name}.scss"
      template "component.tsx",     "app/javascript/components/#{file_name}/#{file_name}.tsx"
      template "component.e2e.ts",  "app/javascript/components/#{file_name}/test/#{file_name}.e2e.ts"
      template "component.spec.ts", "app/javascript/components/#{file_name}/test/#{file_name}.spec.ts"
    end

    private

    def file_name
      @fname ||= super.dasherize
    end

    def class_name
      @cname ||= super.underscore.classify
    end

    def validate_component_name!
      if !file_name.include?('-') || file_name.start_with?('-')
        raise "Invalid custom element name `#{file_name}'.\n\n" \
              "The custom element name must have at least one dash '-' in its name by specification, and can not start with a dash."
      end

      if RESERVED_COMPONENT_NAMES.include?(file_name)
        raise "Invalid custom element name `#{file_name}'.\n\n" \
              "The name `#{file_name}' is a reserved element name. The reserved element names are the following:\n\n" \
              "    #{RESERVED_COMPONENT_NAMES.join(", ")}\n\n"
      end
    end
  end
end