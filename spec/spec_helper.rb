require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

require 'rspec'
require_relative 'support/cat'
require_relative '../lib/optional'


RSpec.configure do |config|
  config.order = :rand
  config.color_enabled = true
end
