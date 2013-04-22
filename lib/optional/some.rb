class Some
  include Option

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def each
    yield value
  end

  def none?(&block)
    block.nil? ? false : super
  end

  def value_or(default=nil)
    value
  end

  def some?(type=value.class)
    value.class == type
  end

  def & other
    other.and_option(self)
  end

  def == other
    other.is_a?(Some) && value == other.value
  end

  def | other
    self
  end

  def merge(other, &block)
    other.match do |m|
      m.some { |v| block.nil? ? Some[*value, v] : Some[block.call(*value, v)] }
      m.none { self }
    end
  end

  def to_s
    "Some[#{value}]"
  end

  def self.[](*values)
    new(values.size == 1 ? values.first : values)
  end

end
