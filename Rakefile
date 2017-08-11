require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

task test: :spec

RuboCop::RakeTask.new

require 'yard'
YARD::Rake::YardocTask.new

require 'yardstick/rake/measurement'
Yardstick::Rake::Measurement.new do |measurement|
  measurement.output = 'measurement/report.txt'
end

require 'yardstick/rake/verify'
Yardstick::Rake::Verify.new do |verify|
  verify.threshold = 50.0
end

task default: [:spec, :rubocop]
