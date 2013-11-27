module None
  include Option
  extend self

  def none?
    true
  end

  def some?(_=false)
    false
  end
end
