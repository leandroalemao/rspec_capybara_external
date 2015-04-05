require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara/dsl'
require 'rspec'
require 'pry'

Capybara.app_host = "http://speedybitcoin.co.uk/home"

Capybara.default_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, timeout: 60)
end

Capybara.run_server = false

RSpec.configure do |config|
  config.include Capybara::DSL
end
