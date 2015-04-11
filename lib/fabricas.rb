# Copyright (c) 2015 Julio Lopez

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
module Fabricas
  VERSION = "1.1.0"
  @factories = {}
  def self.factories; @factories; end

  def self.define(&block)
    module_eval(&block)
  end

  def self.factory(klass, args = {}, &block)
    _o = args.fetch(:parent, nil)
    if block_given?
      factories[klass] = CleanRoom.new(args.fetch(:class_name, nil) ||  (_o.class_name if _o) || klass)
      factories[klass].attributes = _o.attributes.clone if _o
      factories[klass].instance_eval(&block)
    end
  end

  def self.build(klass, values = {})
    _i = const_get(factories[klass].class_name.capitalize).new
    attributes = factories[klass].attributes.merge(values)
    attributes.each do |name, value|
      _i.send("#{name}=", value.is_a?(Proc) ? _i.instance_eval(&value) : value)
    end
    _i
  end

  class CleanRoom < BasicObject
    attr_accessor :class_name, :attributes

    def initialize(name)
      @attributes = {}
      @class_name = name.is_a?(::String) ? name.downcase.to_sym : name
    end

    def method_missing(method_name, *args, &block)
      attributes[method_name] = args.first || block
    end

    def factory(klass, args={}, &block)
      ::Fabricas.factory(klass, args.merge(parent: self), &block)
    end
  end
end