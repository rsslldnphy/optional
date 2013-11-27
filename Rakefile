#!/usr/bin/env rake
require 'coveralls/rake/task'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new
Coveralls::RakeTask.new

desc 'Run all tests and code quality tools'
task :test do
  Rake::Task['spec'].invoke
  Rake::Task['coveralls:push'].invoke
end

task default: "test"
