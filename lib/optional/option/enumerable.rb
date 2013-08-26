module Option
  module Enumerable
    include ::Enumerable

    def to_ary
      to_a
    end

    def flatten
      from_array to_ary.flatten
    end

    def juxt(*methods)
      map { |v| methods.map { |m| v.send(m) } }
    end

    def map_through(*methods)
      methods.reduce(self) { |acc, m| acc.map(&m) }
    end

    def map
      from_array super
    end
    alias_method :collect, :map
    alias_method :collect_concat, :map

    def flat_map(&block)
      map(&block).flatten
    end

    def detect
      from_value super
    end
    alias_method :find, :detect

    def select
      from_array super
    end
    alias_method :find_all, :select

    def grep(value)
      from_array super
    end

    def reject(*args, &block)
      from_array to_a.reject(*args, &block)
    end

    def reduce(*args, &block)
      if none? && (args.size < 1 || args.size < 2 && block.nil?)
        raise ValueOfNoneError
      end
      super
    end
    alias_method :inject, :reduce
  end
end
