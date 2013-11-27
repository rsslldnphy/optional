class Optional::Match
  def initialize(option)
    @_option = option
  end

  def _evaluate
    yield self
    _result or fail BadMatchError, _option
  end

  def some(match = always, &block)
    @_result ||= block.call(_option.value) if _option.some? && match === _option.value
  end

  def none(&block)
    @_result ||= block.call if _option.none?
  end

  private
  attr_reader :_option, :_result

  def always
    ->(x) { true }
  end
end

class BadMatchError < StandardError
  def initialize(value)
    super "No match for value: #{value.inspect}"
  end
end

Option::BadMatchError = BadMatchError # for backwards-compatibility
