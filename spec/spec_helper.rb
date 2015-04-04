require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara/dsl'
require 'rspec'
require 'pry'

Capybara.app_host = "http://speedybitcoin.co.uk/home"
Capybara.default_driver = :poltergeist
Capybara.run_server = false

RSpec.configure do |config|
  config.include Capybara::DSL
end
