require 'spec_helper'

class BuilderModel
  include Id::Model

  field :foo
  field :bar
  has_one :nested_builder_model
  has_many :nested_builder_models

  class NestedBuilderModel
    include Id::Model

    field :baz
  end

end

module Id
  describe Model::Builder do

    it 'models can be built using a builder' do
      BuilderModel.builder.build.should be_a BuilderModel
    end

    it 'defines chainable setter methods for each field' do
      model = BuilderModel.builder.foo(4).bar("hello cat").build
      model.foo.should eq 4
      model.bar.should eq "hello cat"
    end

    it 'allows setting of has_one associations using their respective builders' do
      nested_model = BuilderModel::NestedBuilderModel.builder.baz(:quux).build
      model = BuilderModel.builder.nested_builder_model(nested_model).build
      model.nested_builder_model.baz.should eq :quux
    end

    it 'allows setting of has_many associations using their respective builders' do
      nested_model = BuilderModel::NestedBuilderModel.builder.baz(:quux).build
      model = BuilderModel.builder.nested_builder_models([nested_model]).build
      model.nested_builder_models.first.baz.should eq :quux
    end

  end
end
