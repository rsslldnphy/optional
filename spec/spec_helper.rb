require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

require 'rspec'
require_relative '../lib/id'


RSpec.configure do |config|
  config.order = :rand
  config.color_enabled = true
end
