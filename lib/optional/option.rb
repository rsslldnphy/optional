module Option
  include Enumerable

  def self.[](*values)
    !values.first.nil? ? Some[*values] : None
  end

  def map
    Option[*super]
  end
  alias collect map

  def flat_map
    Option[*super]
  end
  alias collect_concat flat_map

  def detect
    Option[*super]
  end
  alias find detect

  def select
    Option[*super]
  end
  alias find_all select

  def grep(pattern)
    Option[*super]
  end

  def reject
    Option[*super]
  end

  def reduce(*args)
    super or fail ValueOfNoneError
  end
  alias inject reduce

  def flatten
    Option[*to_a.flatten]
  end

  alias to_ary to_a
end
