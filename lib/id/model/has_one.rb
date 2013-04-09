module Id
  module Model
    class HasOne < Association

      def define_getter
        field = self
        model.send :define_method, name do
          memoize field.name do
            child = data.fetch(field.key) { raise MissingAttributeError }
            field.type.new(child) unless child.nil?
          end
        end
      end

    end

    class HasOneOption < Association

      def define_getter
        field = self
        model.send :define_method, name do
          memoize field.name do
            child = data.fetch(field.key, nil)
            child.nil? ? None : Some[field.type.new(child)]
          end
        end
      end

    end
  end
end
