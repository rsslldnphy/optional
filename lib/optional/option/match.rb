module Option
  class Match

    def some(guard=always, &block)
      some_clauses << SomeClause.new(guard, block)
    end

    def none(&block)
      self.none_clause = NoneClause.new(block)
    end

    def evaluate(option)
      case option
      when Some
        matched(option).evaluate(option.value)
      when None
        none_clause.evaluate
      end
    end

    private

    def some_clauses
      @some_clauses ||= []
    end

    def none_clause
      @none_clause ||= NoneClause.new(lambda {})
    end

    def matched(option)
      some_clauses.find { |clause| clause.matches? option.value }.tap do |match|
        raise Option::BadMatchError if match.nil?
      end
    end

    def always
      lambda { |x| true }
    end

    attr_writer :none_clause

    class SomeClause

      def initialize(guard=always, block=lambda{})
        @guard = guard
        @block = block
      end

      def matches?(value)
        guard.call(value)
      end

      def evaluate(value)
        block.call(value)
      end

      private

      attr_reader :block

      def guard
        @guard.is_a?(Proc) ? @guard : (lambda { |x| x == @guard })
      end

    end

    class NoneClause

      def initialize(block)
        @block = block
      end

      def evaluate
        block.call
      end

      private

      attr_reader :block
    end

  end
end
