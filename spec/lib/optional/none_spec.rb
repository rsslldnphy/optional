require 'spec_helper'

describe None do

  it { should be_none            }
  it { should_not be_some        }
  it { should_not be_some String }
end
