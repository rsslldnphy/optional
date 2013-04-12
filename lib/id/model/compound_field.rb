module Id
  module Model
    class CompoundField < Association

      def initialize(model, name, fields, options)
        @fields = fields
        super(model, name, options)
      end

      def define_getter
        field = self
        model.send :define_method, name do
          memoize field.name do
            compound = Hash[field.fields.map { |k,v| [k.to_s, send(v) { raise MissingAttributeError}]}]
            field.type.new(compound)
          end
        end
      end

      attr_accessor :fields
    end
  end
end
