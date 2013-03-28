require 'active_support/inflector'
require 'active_support/core_ext/string/inflections'
require 'bson'

module Old
  def initialize(data)
    @data = data
  end

  def data
    @data.has_key?(:_id) ? @data : @data.merge!(_id: BSON::ObjectId.new)
  end

  def self.included(base)
    base.extend(DocumentDescriptor)
  end

  module DocumentDescriptor

    def has_one(f, options={})
      type = options.fetch(:type, nil) || association_class(f)
      key = options.fetch(:key, nil) || f
      define_method f do
        instance_variable_get(:"@#{f}") ||
          instance_variable_set(:"@#{f}", type.new(data.fetch(key.to_s)))
      end
    end

    def has_many(f, options={})
      type = options.fetch(:type, nil) || association_class(f)
      key = options.fetch(:key, nil) || f
      define_method f do
        instance_variable_get(:"@#{f}") ||
          instance_variable_set(:"@#{f}", data.fetch(key.to_s).map {|x| type.new(x) } )
      end
    end

    def field(f, options={})
      key = options.fetch(:key, f)
      if options.has_key?(:default)
        define_field_with_default(f, key, options)
      else
        define_field(f, key)
      end
    end

    private

    def association_class(f)
      class_name = f.to_s.classify
      hierarchy = name.split("::").reduce([]) do |acc, name|
        acc + ["#{acc.last + '::' unless acc.last.nil?}#{name}"]
      end.map(&:constantize)
      module_name = hierarchy.find{ |m| m.const_defined? class_name }
      if const_defined?(class_name) then const_get(class_name)
      elsif module_name.nil? then class_name.constantize
      else module_name.const_get(class_name) end
    end


    def define_field(f, key)
      define_method f do
        data.fetch(key.to_s)
      end
    end

    def define_field_with_default(f, key, options)
      default = options.fetch(:default)
      default_proc = default.is_a?(Proc) ? default : lambda { default }
      define_method f do
        data.fetch(key.to_s, default_proc.call)
      end
    end

  end

end
