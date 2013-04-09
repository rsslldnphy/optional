require 'spec_helper'

class Cat
  include Id::Model
end

class OptionalModel
  include Id::Model

  has_one :cat, optional: true
end

module Id
  module Model

    describe HasOneOption do

      it 'returns a none if the key is missing' do
        OptionalModel.new({}).cat.should be_none
      end

      it 'returns a some if the key is there' do
        OptionalModel.new(cat: {}).cat.should be_some(Cat)
      end

    end

  end
end
