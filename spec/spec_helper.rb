require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

require 'rspec'
require 'support/cat'
require 'optional'


RSpec.configure do |config|
  config.order = :rand
  config.color_enabled = true
end
