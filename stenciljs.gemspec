lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "stenciljs/version"

Gem::Specification.new do |s|
  s.name        = 'stenciljs'
  s.version     = Stenciljs::VERSION
  s.date        = '2023-03-23'
  s.summary     = "StencilJS for Rails"
  s.description = "StencilJS for Rails"
  s.authors     = ["Niels van der Zanden"]
  s.email       = 'niels@phusion.nl'
  s.files       = Dir.glob("lib/**/*.*")
  s.homepage    = 'https://github.com/scarhand/rails-stenciljs'
  s.license     = 'MIT'

  s.add_dependency "railties",      ">= 7.0"
  s.add_dependency "activesupport", ">= 7.0"

  s.add_development_dependency "bundler",  "~> 1.16"
  s.add_development_dependency 'rspec'

end
