class Some
  include Option

  def self.[](*values)
    fail NilIsNotSomeError if values.first.nil?
    new(values.size == 1 ? values.first : values)
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

  def value_or(_=nil)
    value
  end

  def each
    yield value
  end

  def eql?(other)
    other.is_a?(Some) && value == other.value
  end
  alias == eql?

  def hash
    value.hash
  end

  def & other
    other.map { |v| Array(value) + Array(v) }
  end

  def | other
    self
  end

  def merge other, &block
    merged = self & other | self
    block.nil? || other.none? ? merged : merged.map { |a, b| block.call(a, b) }
  end

  def to_s
    "Some#{Array(value)}"
  end
  alias inspect to_s

  def match(&block)
    Optional::Match.new(self)._evaluate(&block)
  end

  attr_reader :value

end

class NilIsNotSomeError < StandardError
end
