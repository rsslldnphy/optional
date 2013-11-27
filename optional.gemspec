Gem::Specification.new do |s|
  s.name          = 'optional'
  s.version       = '0.1'
  s.date          = '2013-11-27'
  s.summary       = "Option types to make nils a thing of the past"
  s.description   = "Based on the Haskell Maybe monad / Scala Option class"
  s.author        = "Russell Dunphy"
  s.email         = 'rssll@rsslldnphy.com'
  s.files         = `git ls-files`.split($\)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.homepage      = 'http://github.com/rsslldnphy/optional'
  s.license       = 'MIT'

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "mocha"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "coveralls"
end
