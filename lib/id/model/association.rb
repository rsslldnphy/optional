module Id
  module Model
    class Association < Field

      def type
        options.fetch(:type) { inferred_class }
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
        @hierarchy ||= Hierarchy.new(model.name, inferred_class_name)
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
end
