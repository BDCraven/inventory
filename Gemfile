# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.4.0'
git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'data_mapper'
gem 'dm-postgres-adapter'

group :development, :test do
  gem 'database_cleaner'
  gem 'rspec'
  gem 'rubocop'
  gem 'simplecov', require: false, group: :test
  gem 'simplecov-console', require: false, group: :test
end
