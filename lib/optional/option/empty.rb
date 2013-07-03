module Option
  class Empty
    def self.[] value
      value.respond_to?(:empty?) ? value.empty? : !value
    end
  end
end
