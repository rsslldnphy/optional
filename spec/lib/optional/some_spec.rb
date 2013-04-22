require 'spec_helper'

describe Some do

  let (:cat) { Cat.new("MOGGIE!") }
  let (:dog) { Dog.new("DOGGIE!") }

  subject { Some[cat] }

  it { should be_some }
  it { should be_some Cat }
  it { should_not be_some Dog }

  it { should_not be_none }

  it { should eq Some[cat] }
  it { should_not eq Some[dog] }
  it { should_not eq None }

  it "has a value" do
    Some[cat].value.should eq cat
  end

  it "can be passed a default value but won't use it" do
    Some[cat].value_or { dog }.should eq cat
    Some[cat].value_or(dog).should eq cat
  end

  it "can be anded with another some" do
    (Some[cat] & Some[dog]).should eq Some[cat, dog]
  end

  it "can be anded with a none, resulting in none" do
    (Some[cat] & None).should eq None
  end

  it "can be ored with another some" do
    (Some[cat] | Some[dog]).should eq Some[cat]
  end

  it "can be ored with a none resulting in itself" do
    (Some[cat] | None).should eq Some[cat]
  end

  it "prints as Some[value]" do
    Some[4].to_s.should eq "Some[4]"
  end

  describe '#merge' do
    it 'can be merged with another some' do
      Some[3].merge(Some[4]).should eq Some[3,4]
    end

    it 'can be merged with another merged some' do
      Some[3, 4].merge(Some[5]).should eq Some[3, 4, 5]
    end

    it 'can be merged with another some using an operation' do
      Some[3].merge(Some[4], &:+).should eq Some[7]
    end

    it 'can be merged with a none' do
      Some[3].merge(None, &:+).should eq Some[3]
    end
  end

end
