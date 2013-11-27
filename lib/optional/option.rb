module Option
  def self.[](value)
    !value.nil? ? Some[value] : None
  end
end
