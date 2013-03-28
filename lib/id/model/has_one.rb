module Id
  module Model
    class HasOne < Association

      def define
        field = self
        model.send :define_method, name do
          memoize field.name do
            field.type.new(data.fetch(field.key) { raise MissingAttributeError })
          end
        end
      end

    end
  end
end
