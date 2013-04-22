module None
  include Option
  extend self

  def each
  end

  def none?
    true
  end

  def some?(type=nil)
    false
  end

  def value
    raise Option::ValueOfNoneError
  end

  def value_or(default=nil, &block)
    block.nil? ? default : block.call
  end

  def & other
    self
  end

  def | other
    other
  end

  def to_s
    "None"
  end

  def merge other
    other
  end
end
