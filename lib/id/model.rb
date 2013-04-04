module Id
  module Model
    attr_reader :data

    def initialize(parent_setter=identity, data)
      @parent_setter = parent_setter
      @data = Hashifier.new(data).hashify
    end

    def set(values)
      parent_setter.call self.class.new(data.merge(values))
    end

    def remove(*keys)
      self.class.new(data.except(*keys.map(&:to_s)))
    end

    private

    attr_reader :parent_setter

    def identity
      lambda { |m| m }
    end

    def setter(f)
      lambda { |v| set(f => v) }
    end

    def self.included(base)
      base.extend(Descriptor)
    end

    def memoize(f, &b)
      instance_variable_get("@#{f}") || instance_variable_set("@#{f}", b.call)
    end

    module Descriptor
      def field(f, options={})
        Field.new(self, f, options).define
      end

      def has_one(f, options={})
        HasOne.new(self, f, options).define
      end

      def has_many(f, options={})
        HasMany.new(self, f, options).define
      end

      def builder
        builder_class.new(self)
      end

      private

      def builder_class
        @builder_class ||= Class.new { include Builder }
      end
    end

  end
end
