class Some
  include Option

  def self.[](value)
    fail NilIsNotSomeError if value.nil?
    new(value)
  end

  def initialize(value)
    @value = value
  end

  def some?(type = value.class)
    value.is_a?(type)
  end

  def none?
    false
  end

  def eql?(other)
    other.is_a?(Some) && value == other.value
  end
  alias == eql?

  def to_s
    "Some[#{value}]"
  end

  def inspect
    "Some[#{value.inspect}]"
  end

  def value_or(_=nil)
    value
  end

  def match(&block)
    Optional::Match.new(self)._evaluate(&block)
  end

  attr_reader :value

end

class NilIsNotSomeError < StandardError
end
