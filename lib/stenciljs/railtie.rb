require "rails/railtie"

module Stenciljs
  class Railtie < ::Rails::Railtie
    config.stenciljs = ActiveSupport::OrderedOptions.new
    config.stenciljs.port = 3333

    initializer :stenciljs, group: :all do |app|
      app.config.assets.paths += %w(public/components/build/)
    end

    rake_tasks do
      load "tasks/stenciljs.rake"
    end

    server do
      Process.fork { system "./node_modules/.bin/stencil build --dev --watch --serve --port #{Rails.configuration.stenciljs.port}" }
    end
  end
end
