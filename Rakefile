require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

task test: :spec

RuboCop::RakeTask.new

task default: [:spec, :rubocop]
