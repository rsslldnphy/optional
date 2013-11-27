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

end

class ValueOfNoneError < StandardError
end
Option::ValueOfNoneError = ValueOfNoneError # for backwards compatibility
