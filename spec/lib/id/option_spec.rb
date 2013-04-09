require 'spec_helper'

module Id

  describe Option do

    subject do
      Option.match option do
        some { |x| x.succ }
        none { :canteloupe }
      end
    end

    context 'passed none' do
      let (:option) { None }
      it { should eq :canteloupe }
    end

    context 'passed some' do
      let (:option) { Some[7] }
      it { should eq 8 }
    end

    it 'allows guards that are constants' do
      Option.match Some[5] do
        some(3) { :hello }
        some(5) { :xyzzy }
      end.should eq :xyzzy
    end

    it 'allows guards that are lambdas' do
      Option.match Some[5] do
        some ->(x){ x > 6 } { :hello }
        some ->(x){ x > 3 } { :xyzzy }
        none                { :cats  }
      end.should eq :xyzzy
    end

    it 'throws a BadMatchError if there is no matching clause' do
      expect do
        Option.match Some[5] do
          some(4) { :hello }
          none    { :cats  }
        end
      end.to raise_error BadMatchError
    end

    it 'throws an argument error if it is passed a non-option' do
      expect do
        Option.match 5 do
        end
      end.to raise_error ArgumentError
    end

    it 'allows matching on class' do
      Option.match Some[5] do
        some (kind_of Fixnum) { :cats }
        some (kind_of String) { :dogs }
      end.should eq :cats
    end
  end

  describe None do

    subject { None }

    it 'can be mapped' do
      None.map(&:foo).should eq []
    end

    it { should be_none }
    it { should_not be_some }

    it 'is not equal to anything' do
      subject.should_not eq subject
    end
  end

  describe Some do

    it 'can be mapped' do
      Some[5].map(&:succ).should eq [6]
    end

    subject { Some[6] }

    it { should_not be_none }
    it { should be_some }

    it 'is equal to other somes with the same value' do
      subject.should eq Some[6]
    end

    it 'is not equal to other somes with different values' do
      subject.should_not eq Some[5]
    end

    it 'is not equal to none' do
      subject.should_not eq None
    end
  end
end
