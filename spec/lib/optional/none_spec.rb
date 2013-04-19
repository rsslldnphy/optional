require 'spec_helper'

describe None do

  let (:cat) { Cat.new("MOGGIE!") }

  subject { None }

  it { should be_none }
  it { should_not be_some }
  it { should_not be_some Cat }

  it { should eq None }
  it { should_not eq Some[cat] }

  it "does not have a value" do
    expect { subject.value }.to raise_error Option::ValueOfNoneError
  end

  it "does, however, allow you to supply a default in place of a value" do
    subject.value_or { cat }.should eq cat
  end

  it "can be anded with another none, yielding none" do
    (None & None).should be_none
  end

  it "can be anded with a some, yielding none" do
    (None & Some[cat]).should be_none
  end

  it "can be ored with another none, yielding none" do
    (None | None).should be_none
  end

  it "can be ored with a some, yielding the some" do
    (None | Some[cat]).should eq Some[cat]
  end

  it "prints as None" do
    None.to_s.should eq "None"
  end
end
