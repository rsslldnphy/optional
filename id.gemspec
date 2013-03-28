Gem::Specification.new do |s|
  s.name        = 'id'
  s.version     = '0.0.1'
  s.date        = '2013-03-28'
  s.summary     = "Simple models based on hashes"
  s.description = "Developed at On The Beach Ltd. Contact russell.dunphy@onthebeach.co.uk"
  s.authors     = ["Russell Dunphy", "Radek Molenda"]
  s.email       = ['russell@russelldunphy.com', 'radek.molenda@gmail.com']
  s.files       = ["lib/id.rb"]
  s.homepage    = 'http://rubygems.org/gems/id'

  s.add_dependency "active_support"

  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
end
