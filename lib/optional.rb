module Option
  def self.[](value)
    !value.nil? ? Some[value] : None
  end
end

module None
  include Option
  extend self

  def none?
    true
  end
end

class Some
  include Option

  def self.[](value)
    new(value)
  end

  def initialize(value)
    @value = value
  end

  def some?
    true
  end

  attr_reader :value

end
