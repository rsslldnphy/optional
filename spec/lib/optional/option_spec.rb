require 'spec_helper'

describe Option do
  context 'creation using the square bracket syntax' do

    it 'will return a `Some` if the value is non-nil' do
      expect(Option[2]).to be_some
    end

    it 'will return a `None` if the value in nil' do
      expect(Option[nil]).to be_none
    end
  end
end
