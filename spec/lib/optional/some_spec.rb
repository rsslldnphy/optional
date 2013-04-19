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

end
