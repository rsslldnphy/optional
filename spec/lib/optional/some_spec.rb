require 'spec_helper'

describe Some do
  subject { Some[:value] }

  it { should_not be_none          }
  it { should be_some              }
  it { should be_some Symbol       }
  it { should_not be_some Fixnum   }

  it { should eq Some[:value]      }
  it { should_not eq Some[:other]  }
  it { should_not eq None          }

  it 'has a value, which can be retrieved' do
    expect(subject.value).to eq :value
  end

  it 'cannot be created with a nil value' do
    expect { Some[nil] }.to raise_error NilIsNotSomeError
  end

  describe '#value_or' do
    it 'returns the value of the `Some`, ignoring the default' do
      expect(subject.value_or :default).not_to eq :default
    end
    it 'does not evaluate the default if it is passed as a block' do
      expect { subject.value_or { fail } }.not_to raise_error
    end
  end

  context '#to_s (creates a readable representation)' do
    subject { Some[:value].to_s }
    it { should eq 'Some[value]' }
  end

  context '#inspect (calls inspect on the value in turn)' do
    subject { Some[:value].inspect }
    it { should eq 'Some[:value]' }
  end

end
