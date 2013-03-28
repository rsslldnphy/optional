require 'spec_helper'

class NestedModel
  include Id
end

class TestModel
  include Id

  field :foo
  field :bar, key: 'baz'
  field :quux, default: 'kwak'

  has_one :aliased_model, type: NestedModel
  has_one :nested_model
  has_one :extra_nested_model

  class ExtraNestedModel
    include Id
  end
end

describe Id do
  let (:model) { TestModel.new(foo: 3, baz: 6, aliased_model: {}) }

  describe ".field" do
    it 'defines an accessor on the model' do
      model.foo.should eq 3
    end

    it 'allows key aliases' do
      model.bar.should eq 6
    end

    it 'allows default values' do
      model.quux.should eq 'kwak'
    end

  end

  describe ".has_one" do
    it "allows nested models" do
      model.aliased_model.should be_a NestedModel
    end
  end
end

describe Id::HasOne do

  module Foo
    module Bar
      module Baz
        class Quux
        end
      end
    end
  end

  let (:model) { stub(name: "Foo::Bar::Baz::Quux") }
  let (:has_one) { Id::HasOne.new(model, "yak", {}) }

  describe "hierarchy" do
    it "builds the class and module hierarchy for the model" do
      has_one.hierarchy.constants.should eq [
        Foo::Bar::Baz::Quux,
        Foo::Bar::Baz,
        Foo::Bar,
        Foo
      ]
    end
  end
end
