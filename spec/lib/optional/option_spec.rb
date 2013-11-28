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

  context 'merging' do
    context 'merging a `None` with `Some[:value]`' do
      subject { None.merge(Some[:value]) }
      it { should eq Some[:value] }
    end

    context 'merging `Some[:value]` with a `None`' do
      subject { Some[:value].merge(None) }
      it { should eq Some[:value] }
    end

    context 'merging `Some[:value]` with `Some[:other]`' do
      subject { Some[:value].merge(Some[:other]) }
      it { should eq Some[:value, :other] }
    end

    context 'merging two `None`s with a block' do
      subject { None.merge(None, &:+) }
      it { should be None }
    end

    context 'merging a `None` and a `Some` with a block' do
      subject { None.merge(Some["Cat!"], &:+) }
      it { should eq Some["Cat!"] }
    end

    context 'merging a `Some` and a `None` with a block' do
      subject { Some["Cat!"].merge(None, &:+) }
      it { should eq Some["Cat!"] }
    end

    context 'merging two `Some`s with a block' do
      subject { Some["Hello "].merge(Some["Cat!"], &:+) }
      it { should eq Some["Hello Cat!"] }
    end

  end
end
