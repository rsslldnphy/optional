require_relative 'old'

module Id

  class MissingAttributeError < StandardError
  end

  attr_reader :data

  def initialize(data)
    @data = Hash[data.map { |k, v| [k.to_s, v] }]
  end

  def self.included(base)
    base.extend(Descriptor)
  end

  module Descriptor
    def field(f, options={})
      Field.new(self, f, options).define
    end

    def has_one(f, options={})
      HasOne.new(self, f, options).define
    end
  end

  class Field

    def initialize(model, name, options)
      @model = model
      @name = name
      @options = options
    end

    def define
      field = self
      model.define_method name do
        data.fetch(field.key) { field.default or raise MissingAttributeError }
      end
    end

    def key
      options.fetch(:key, name).to_s
    end

    def default
      options.fetch(:default, nil)
    end

    attr_reader :model, :name, :options
  end

  class HasOne < Field
    def define
      field = self
      model.define_method name do
        field.type.new(data.fetch(field.key) { raise MissingAttributeError })
      end
    end

    def type
      options.fetch(:type)
    end

    def inferred_class
      if hierarchy.defines_child?
        hierarchy.parent.const_get(inferred_class_name)
      else
        inferred_class_name.constantize
      end
    end

    def inferred_class_name
      @inferred_class_name ||= name.to_s.classify
    end

    def hierarchy
      @hierarchy ||= Hierarchy.new(model.name, name)
    end

    class Hierarchy

      def initialize(path, child)
        @path = path
        @child = child
      end

      def defines_child?
        !parent.nil?
      end

      def parent
        @parent ||= constants.find { |c| c.const_defined? child }
      end

      def constants
        hierarchy.map(&:constantize)
      end

      private

      def hierarchy(name=path)
        name.match /(.*)::.*$/
        $1 ? [name] + hierarchy($1) : [name]
      end

      attr_reader :path, :child
    end
  end
end
