module Fabricas
  @items = {}
  def self.items; @items; end

  def self.define(&block)
    module_eval(&block)
  end

  def self.factory(klass, args = {}, &block)
    class_name = args.fetch(:class_name, nil)
    if block_given?
      Fabricas.items[klass] = CleanRoom.new
      Fabricas.items[klass].class_name = class_name.downcase.to_sym if class_name
      Fabricas.items[klass].instance_eval(&block)
    end
  end

  def self.build(klass, values = {})
    _k = items[klass].class_name ? items[klass].class_name : klass
    _i = const_get(_k.capitalize).new
    attributes = items[klass].attributes.merge(values)
    attributes.each do |name, value|
      _i.send("#{name}=", value.is_a?(Proc) ? value.call : value)
    end
    _i
  end

  class CleanRoom < BasicObject
    attr_reader :attributes
    attr_accessor :class_name

    def initialize
      @attributes = {}
    end

    def method_missing(method_name, *args, &block)
      attributes[method_name] = args.first || block
    end
  end
end