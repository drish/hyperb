require 'simplecov'
require 'coveralls'

Coveralls.wear!
SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter, Coveralls::SimpleCov::Formatter]

SimpleCov.start do
  add_filter '/spec/'
  minimum_coverage(95.5)
end

require 'hyperb'
require 'bundler/setup'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow: 'coveralls.io')

RSpec.configure do |config|

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.run_all_when_everything_filtered = true
  config.filter_run focus: true
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def base_url(client)
  host = "#{client.region}.hyper.sh".freeze
  "https://#{host}/#{Hyperb::Request::VERSION}".freeze
end

def funcs_base_url(client)
  "https://#{client.region}.hyperfunc.io/".freeze
end
