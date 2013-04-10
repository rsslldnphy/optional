require 'spec_helper'

module Id

  describe Option do

    subject do
      option.match do |m|
        m.some { |x| x.succ }
        m.none { :canteloupe }
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
      Some[5].match do |m|
        m.some(3) { :hello }
        m.some(5) { :xyzzy }
      end.should eq :xyzzy
    end

    it 'allows guards that are lambdas' do
      Some[5].match do |m|
        m.some ->(x){ x > 6 } { :hello }
        m.some ->(x){ x > 3 } { :xyzzy }
        m.none                { :cats  }
      end.should eq :xyzzy
    end

    it 'throws a BadMatchError if there is no matching clause' do
      expect do
        Some[5].match do |m|
          m.some(4) { :hello }
          m.none    { :cats  }
        end
      end.to raise_error BadMatchError
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

    it 'raises an error if you try to access its value' do
      expect { subject.value }.to raise_error NoOptionValueError
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

    it 'can be flatmapped into a collection' do
      [Some[4], None, Some[3], Some[2], None, None].flat_map(&:to_a).should eq [4,3,2]
    end
  end
end
