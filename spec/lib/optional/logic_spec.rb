require 'spec_helper'

describe Option do
  context 'logical AND (&)' do

    context '`None & None`' do
      subject { None & None }
      it { should be None }
    end

    context '`None & Some[value]`' do
      subject { None & Some[:value] }
      it { should be None }
    end

    context '`Some[value] & None`' do
      subject { Some[:value] & None }
      it { should be None }
    end

    context '`Some[:value] & Some[:other]`' do
      subject { Some[:value] & Some[:other] }
      it { should eq Some[:value, :other] }
    end

  end

  context 'logical OR (|)' do
    context '`None | None`' do
      subject { None | None }
      it { should be None }
    end

    context '`None | Some[value]`' do
      subject { None | Some[:value] }
      it { should eq Some[:value] }
    end

    context '`Some[value] | None`' do
      subject { Some[:value] | None }
      it { should eq Some[:value] }
    end

    context '`Some[:value] | Some[:other]`' do
      subject { Some[:value] | Some[:other] }
      it { should eq Some[:value] }
    end
  end
end
