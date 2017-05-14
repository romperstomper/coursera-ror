require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
#include Capybara::DSL

RSpec.configure do |config|
  config.include Capybara::DSL
end
