module Id
  module Model
    class Field

      def initialize(model, name, options)
        @model = model
        @name = name
        @options = options
      end

      def define_getter
        field = self
        model.send :define_method, name do
          data.fetch(field.key) { field.default or raise MissingAttributeError }
        end
      end

      def define_setter
        model.send(:builder_class).define_setter name
      end

      def define
        define_getter
        define_setter
      end

      def key
        options.fetch(:key, name).to_s
      end

      def default
        options.fetch(:default, nil)
      end

      attr_reader :model, :name, :options
    end

  end
end
