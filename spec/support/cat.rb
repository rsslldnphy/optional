class Cat
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def == other
    other.is_a?(Cat) && other.name == name
  end
end

class Dog
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def == other
    other.is_a?(Dog) && other.name == name
  end
end
