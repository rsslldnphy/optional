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
          data.fetch(field.key, &field.default_value)
        end
      end

      def define_setter
        model.send(:builder_class).define_setter name
      end

      def define_is_present
        field = self
        model.send :define_method, "#{name}?" do
          data.has_key?(field.key) && !data.fetch(field.key).nil?
        end
      end

      def define
        define_getter
        define_setter
        define_is_present
      end

      def key
        options.fetch(:key, name).to_s
      end

      def default_value
        proc { optional? ? nil : (default or raise MissingAttributeError) }
      end

      def default
        options.fetch(:default, nil)
      end

      def optional?
        options.fetch(:optional, false)
      end

      attr_reader :model, :name, :options
    end

  end
end
