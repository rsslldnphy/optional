module Id
  module Model
    class HasMany < Association

      def define_getter
        field = self
        model.send :define_method, name do
          memoize field.name do
            data.fetch(field.key, []).map { |r| field.type.new(setter(field.key), r) }
          end
        end
      end

    end
  end
end
