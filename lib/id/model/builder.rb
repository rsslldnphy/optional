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

      attr_reader :model, :data

      def self.included(base)
        base.extend(FieldBuilder)
      end

      module FieldBuilder

        def field(f)
          define_method f do |value|
            self.class.new(model, data.merge(f.to_s => value))
          end
        end

      end

    end
  end
end
