module Id
  module Model
    module Builder

      def initialize(model, data={})
        @model = model
        @data = data
      end

      def build
        model.new data
      end

      private

      def set(f, value)
        self.class.new(model, data.merge(f.to_s => ensure_hash(value)))
      end

      def ensure_hash(value)
        case value
        when Id::Model then value.data
        when Array then value.map { |v| ensure_hash(v) }
        else value end
      end

      attr_reader :model, :data

      def self.included(base)
        base.extend(FieldBuilder)
      end

      module FieldBuilder

        def field(f)
          define_method f do |value|
            set(f, value)
          end
        end

      end

    end
  end
end
