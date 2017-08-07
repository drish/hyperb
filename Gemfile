source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

group :test do
  gem 'coveralls'
  gem 'rubocop', '>= 0.46'
end

# Specify your gem's dependencies in hyperb.gemspec
gemspec
