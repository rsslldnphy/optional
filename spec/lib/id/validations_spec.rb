require 'spec_helper'

class ValidatedModel
  include Id::Model
  include ActiveModel::Validations

  field :name

  validates_numericality_of :name

end

module Id
  describe "validations" do
    it 'allows active model validations to be used' do
       ValidatedModel.new({name: "oeu"}).should_not be_valid
    end
  end
end
