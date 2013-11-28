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

  it 'can be created with an empty array' do
    expect(Some[[]].value).to eq []
  end

  it 'can be created with multiple values, becoming a `Some[Array]`' do
    expect(Some[1,2,3].value).to eq [1,2,3]
  end

  describe '#value_or' do
    it 'returns the value of the `Some`, ignoring the default' do
      expect(subject.value_or :default).not_to eq :default
    end
    it 'does not evaluate the default if it is passed as a block' do
      expect { subject.value_or { fail } }.not_to raise_error
    end
  end

  describe '#to_s (creates a readable representation)' do
    subject { Some[:value].to_s }
    it { should eq 'Some[:value]' }

    context 'when the value is an array' do
      subject { Some[:value, :other].to_s }
      it { should eq 'Some[:value, :other]' }
    end
  end

  describe '#inspect (calls inspect on the value in turn)' do
    subject { Some[:value].inspect }
    it { should eq 'Some[:value]' }

    context 'when the value is an array' do
      subject { Some[:value, :other].inspect }
      it { should eq 'Some[:value, :other]' }
    end
  end

  describe '#each' do
    it 'yields to the block with its value as argument' do
      count = 0
      Some[5].each { |value| count += value }
      expect(count).to eq 5
    end
  end
end
