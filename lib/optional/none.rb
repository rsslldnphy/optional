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

  def value_or
    yield
  end

  def & other
    self
  end

  def | other
    other
  end

end
