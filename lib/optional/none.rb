module None
  include Option
  extend self

  def none?
    true
  end

  def some?(_=false)
    false
  end

  def value
    fail ValueOfNoneError
  end

  def value_or(default = nil, &block)
    default || block.call
  end

end

class ValueOfNoneError < StandardError
end
Option::ValueOfNoneError = ValueOfNoneError # for backwards compatibility
