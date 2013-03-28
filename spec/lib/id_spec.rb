require 'spec_helper'

class NestedModel
  include Id::Model
  field :yak
end

class TestModel
  include Id::Model

  field :foo
  field :bar, key: 'baz'
  field :quux, default: 'kwak'

  has_one :aliased_model, type: NestedModel
  has_one :nested_model, key: 'aliased_model'
  has_one :extra_nested_model
  has_one :test_model
  has_many :nested_models

  class ExtraNestedModel
    include Id::Model
    field :cats!
  end
end

describe Id::Model do
  let (:model) { TestModel.new(foo: 3,
                               baz: 6,
                               test_model: {},
                               aliased_model: { 'yak' => 11},
                               nested_models: [{ 'yak' => 11}, { yak: 14 }],
                               extra_nested_model: { cats!: "MIAOW" }) }

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
    it "allows nested models" do
      model.nested_model.should be_a NestedModel
      model.nested_model.yak.should eq 11
    end
    it "allows associations to be nested within the class" do
      model.extra_nested_model.should be_a TestModel::ExtraNestedModel
      model.extra_nested_model.cats!.should eq 'MIAOW'
    end
    it "allows recursively defined models" do
      model.test_model.should be_a TestModel
    end
  end

  describe ".has_many" do
    it 'creates an array of nested models' do
      model.nested_models.should be_a Array
      model.nested_models.first.should be_a NestedModel
      model.nested_models.first.yak.should eq 11
      model.nested_models.last.yak.should eq 14
    end
  end
end

describe Id::Model::HasOne do

  module Foo
    module Bar
      module Baz
        class Quux
        end
      end
    end
  end

  let (:model) { stub(name: "Foo::Bar::Baz::Quux") }
  let (:has_one) { Id::Model::HasOne.new(model, "yak", {}) }

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
