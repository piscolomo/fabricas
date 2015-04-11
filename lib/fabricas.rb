module Fabricas
  @factories = {}
  def self.factories; @factories; end

  def self.define(&block)
    module_eval(&block)
  end

  def self.factory(klass, args = {}, &block)
    if block_given?
      factories[klass] = CleanRoom.new args.fetch(:class_name, nil)
      factories[klass].instance_eval(&block)
    end
  end

  def self.build(klass, values = {})
    _i = const_get((factories[klass].class_name || klass).capitalize).new
    attributes = factories[klass].attributes.merge(values)
    attributes.each do |name, value|
      _i.send("#{name}=", value.is_a?(Proc) ? value.call : value)
    end
    _i
  end

  class CleanRoom < BasicObject
    attr_reader :attributes, :class_name

    def initialize(class_name)
      @attributes = {}
      @class_name = class_name.downcase.to_sym if class_name
    end

    def method_missing(method_name, *args, &block)
      attributes[method_name] = args.first || block
    end
  end
end