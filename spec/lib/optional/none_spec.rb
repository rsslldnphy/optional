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

  describe "#value_or" do
    it 'returns the given default' do
      expect(subject.value_or :default).to eq :default
    end
    it 'can also accept a block as a default value' do
      expect(subject.value_or { :default }).to eq :default
    end
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
