Gem::Specification.new do |s|
  s.name          = 'optional'
  s.version       = '0.0.1'
  s.date          = '2013-04-19'
  s.summary       = "Optional values with pattern matching"
  s.description   = "Developed at On The Beach Ltd. Contact russell.dunphy@onthebeach.co.uk"
  s.authors       = ["Russell Dunphy", "Radek Molenda"]
  s.email         = ['russell@russelldunphy.com', 'radek.molenda@gmail.com']
  s.files         = `git ls-files`.split($\)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.homepage      = 'http://github.com/onthebeach/optional'

  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"

end
