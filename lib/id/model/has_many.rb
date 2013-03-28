module Id
  module Model
    class HasMany < Association

      def define
        field = self
        model.send :define_method, name do
          memoize field.name do
            data.fetch(field.key, []).map { |r| field.type.new(r) }
          end
        end
      end

    end
  end
end
