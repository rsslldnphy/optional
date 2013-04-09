module Id

  class AbstractInstantiationError < StandardError
  end

  class BadMatchError < StandardError
  end

  module Option
    include Enumerable

    class Match

      def initialize(some_blocks=[], none_block=identity)
        @some_blocks = some_blocks
        @none_block = none_block
      end

      def some(guard=always, &block)
        @some_blocks << [guard.is_a?(Proc) ? guard : ->(x) { x == guard}, block]
      end

      def none(&block)
        @none_block = block
      end

      def evaluate(option)
        case option
        when Some
          matched(option).call(option.get)
        when None
          none_block.call
        end
      end

      private

      def matched(option)
        some_blocks.find {|(guard, _)| guard.call(option.get) }.tap do |match|
          raise BadMatchError if match.nil?
        end.last
      end

      def identity
        lambda { |x| x }
      end

      def always
        lambda { |x| true }
      end

      attr_reader :some_blocks, :none_block
    end

    def match(&block)
      Match.new.tap { |m| block.call(m) }.evaluate(self)
    end

  end

  class Some
    include Option

    def self.[](obj)
      new(obj)
    end

    def initialize(obj)
      @obj = obj
    end

    def get
      obj
    end

    def each(&block)
      block.call(obj)
    end

    def none?
      false
    end

    def some?(type=obj.class)
      obj.class == type
    end

    def == other
      case other
      when Some then obj == other.get
      else false
      end
    end

    private

    attr_reader :obj
  end

  module None
    include Option
    extend self

    def each(&block)
    end

    def none?
      true
    end

    def some?(type=nil)
      false
    end

    def == other
      false
    end
  end
end
