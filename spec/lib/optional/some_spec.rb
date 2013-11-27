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

  context '#to_s (creates a readable representation)' do
    subject { Some[:value].to_s }
    it { should eq 'Some[value]' }
  end

  context '#inspect (calls inspect on the value in turn)' do
    subject { Some[:value].inspect }
    it { should eq 'Some[:value]' }
  end

end
