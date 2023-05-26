tasks = {
  "stenciljs:install"           => "Installs and setup stencil with NPM",
  "stenciljs:compile"           => "Compiles stencil bundles based on environment",
  "stenciljs:build"             => "Alias to stencil:build",
# "stencil:clobber"           => "Removes the stencil compiled output directory",
  "stenciljs:check_node"        => "Verifies if Node.js is installed",
  "stenciljs:verify_install"    => "Verifies if Stencil is installed"
}.freeze

desc "Lists all available tasks in stencil"
task :stenciljs do
  puts "Available Stencil tasks are:"
  tasks.each { |task, message| puts task.ljust(30) + message }
end

namespace :stenciljs do
  desc "Support for older Rails versions. Install all JavaScript dependencies as specified via NPM"
  task :npm_install, [:arg1, :arg2] do |task, args|
    system "npm #{args[:arg1]} #{args[:arg2]}"
  end

  desc "Installs and setup stencil with NPM"
  task :install do
    template = File.expand_path("../install/template.rb", __dir__)
    if Rails::VERSION::MAJOR >= 5
      exec "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{template}"
    else
      exec "#{RbConfig.ruby} ./bin/rake rails:template LOCATION=#{template}"
    end
  end

  desc "Verifies if Node.js is installed"
  task :check_node do
    begin
      begin
        node_version = `node -v`
        raise Errno::EINVAL unless node_version.gsub(/v?([0-9]+)\..*/,'\1').strip.to_i >= 18
      rescue Errno::ENOENT
        node_version = `nodejs -v`
        raise Errno::ENOENT if node_version.blank?
      end
    rescue Errno::EINVAL
      $stderr.puts "installed version of Node.js too low. Please update to at least v18."
      $stderr.puts "Exiting!" && exit!
    rescue Errno::ENOENT
      $stderr.puts "Node.js not installed. Please download and install Node.js https://nodejs.org/en/download/"
      $stderr.puts "Exiting!" && exit!
    end
  end

  desc "Verifies if Stencil is installed"
  task verify_install: [:check_node] do
    if Rails.root.join("stencil.config.ts").exist?
      $stdout.puts "Stenciljs is installed 🎉 🍰"
    else
      $stderr.puts "Configuration stencil.config.ts file not found. \n"\
                   "Make sure stencil:install is run successfully before " \
                   "running dependent tasks"
      exit!
    end
  end

  desc "Compiles stencil bundles based on environment"
  task build: :verify_install do
    sh './node_modules/.bin/stencil build'
  end

  desc "Alias to stencil:build"
  task compile: :build

  desc "Starts stencil dev server with --watch option"
  task dev: :verify_install do
    sh "./node_modules/.bin/stencil build --dev --watch --serve"
  end

  desc "Starts stencil dev server with --watch option"
  task start: :dev

  desc "Runs jest tests"
  task :test do
    sh './node_modules/.bin/jest --no-cache'
  end

  namespace :test do
    desc "Runs jest tests with --watch option"
    task :watch do
      sh './node_modules/.bin/jest --watch --no-cache'
    end
  end
end

# Compile web components before we've compiled all other assets during precompilation
if Rake::Task.task_defined?("assets:precompile")
  if Rails::VERSION::STRING >= '5.1.0'
    Rake::Task["assets:precompile"].enhance ["npm:install", "stencil:compile"]
  else
    # For Rails < 5.1
    Rake::Task["stencil:compile"].enhance ['stencil:npm_install']
    Rake::Task["assets:precompile"].enhance ["stencil:compile"]
  end
end
