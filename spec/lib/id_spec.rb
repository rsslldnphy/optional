require 'spec_helper'

class NestedModel
  include Id::Model
  field :yak
end

class TestModel
  include Id::Model

  field :foo
  field :bar, key: 'baz'
  field :qux, optional: true
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


  describe ".new" do
    it 'converts any passed id models to their hash representations' do
      new_model = TestModel.new(test_model: model)
      new_model.test_model.data.should eq model.data
    end
  end

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

    describe "optional flag" do
      it 'allows optional' do
        model.qux.should be_nil
      end

      it 'should not raise an error' do
        expect{model.qux}.not_to raise_error Id::MissingAttributeError
      end
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

  describe "#set" do
    it "creates a new model with the provided values changed" do
      model.set(foo: 999).should be_a TestModel
      model.set(foo: 999).foo.should eq 999
    end

    it "allows setting on nested models" do
      updated = model.nested_model.set(yak: 12345)
      updated.should be_a TestModel
      updated.nested_model.yak.should eq 12345
    end
  end

  describe "#remove" do
    it 'returns a new basket minus the passed key' do
      expect { model.set(foo: 999, bar: 555).remove(:foo, :bar).foo }.to raise_error Id::MissingAttributeError
    end

    it 'does not error if the key to be removed does not exist' do
      expect { model.remove(:not_in_hash) }.to_not raise_error
    end
  end

  describe "#fields are present methods" do
    it 'allows you to check if fields are present' do
      model = TestModel.new(foo: 1)
      model.foo?.should be_true
      model.bar?.should be_false
    end
  end

end

