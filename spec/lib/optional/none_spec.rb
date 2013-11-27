require 'spec_helper'

describe None do

  it { should be_none             }
  it { should_not be_some         }
  it { should_not be_some String  }

  it { should eq None             }
  it { should_not eq Some[:value] }

  it 'does not have a value, and trying to retrieve one raises an error' do
    expect { subject.value }.to raise_error ValueOfNoneError
  end

  context '#to_s' do
    subject { None.to_s }
    it { should eq 'None' }
  end

  context '#inspect' do
    subject { None.inspect }
    it { should eq 'None' }
  end
end
