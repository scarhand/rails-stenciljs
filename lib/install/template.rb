copy_file "#{__dir__}/templates/tsconfig.json",         "tsconfig.json"
template  "#{__dir__}/templates/stencil.config.ts.erb", "stencil.config.ts"
copy_file "#{__dir__}/templates/hello-world.tsx",       "app/javascript/components/hello-world/hello-world.tsx"
copy_file "#{__dir__}/templates/hello-world.scss",      "app/javascript/components/hello-world/hello-world.scss"
copy_file "#{__dir__}/templates/hello-world.e2e.ts",    "app/javascript/components/hello-world/test/hello-world.e2e.ts"
copy_file "#{__dir__}/templates/hello-world.spec.tsx",  "app/javascript/components/hello-world/test/hello-world.spec.tsx"

if File.exist?(".gitignore")
  append_to_file ".gitignore", <<-EOS
/app/javascript/components/components.d.ts
/public/build
EOS
end

say "\nInstalling runtime dependencies"
run "yarn add @stencil/core --cwd ."

say "\nInstalling dev server for live reloading"
run "yarn add --dev @stencil/sass @stencil/dev-server @stencil/utils @types/jest jest jest-cli puppeteer --cwd ."

say "\nInjecting jest configurations"
gsub_file 'package.json', "  }\n}", <<-JSON
  },
  "jest": {
    "transform": {
      "^.+\\\\\\.(ts|tsx)$": "<rootDir>/node_modules/@stencil/core/testing/jest-preprocessor.js"
    },
    "testRegex": "(/__tests__/.*|\\\\\\.(test|spec))\\\\\\.(tsx?|jsx?)$",
    "moduleFileExtensions": [
      "ts",
      "tsx",
      "js",
      "json",
      "jsx"
    ]
  }
}
JSON

gsub_file 'app/views/layouts/application.html.erb', "</head>", <<-HTML.chomp
  <%= javascript_stenciljs_tags %>
  </head>
HTML

if Rails.root.join("Procfile.dev").exist?
  append_to_file "Procfile.dev", "js: bin/rails stenciljs:start\n"
else
  say "\n  Couldn't find Procfile.dev. To compile and watch your stencil components, "\
      " run the following command manually in a separate terminal window:\n\n", :red
  say "    rails stenciljs:start"
end

say "\nstenciljs successfully installed 🎉 🍰", :green