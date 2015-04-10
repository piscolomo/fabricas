module Fabricas
  @items = {}
  def self.items; @items; end

  def self.define(&block)
    FabricasMethods.new.instance_eval(&block)
  end

  def self.build(klass, values = {})
    _i = const_get(klass.capitalize).new
    attributes = items[klass].attributes.merge(values)
    attributes.each do |name, value|
      _i.send("#{name}=", value)
    end
    _i
  end

  class CleanRoom < BasicObject
    attr_reader :attributes

    def initialize
      @attributes = {}
    end

    def method_missing(method_name, *args)
      attributes[method_name] = args.first
    end
  end

  class FabricasMethods
    def factory(klass, &block)
      if block_given?
        Fabricas.items[klass] = CleanRoom.new 
        Fabricas.items[klass].instance_eval(&block)
      end
    end
  end
end