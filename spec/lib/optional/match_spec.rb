require 'spec_helper'
require 'optional/symbol_to_proc'

describe Optional::Match do
  describe '#some' do
    it 'matches any some if no pattern is given' do
      result = Some[:value].match do |m|
        m.some { "matched!" }
      end
      expect(result).to eq "matched!"
    end

    it 'matches a some with a matching value if one is given' do
      result = Some[:catcopter].match do |m|
        m.some(:dogcopter) { "matched dogcopter" }
        m.some(:catcopter) { "matched catcopter" }
      end
      expect(result).to eq "matched catcopter"
    end

    it 'matches anything matching a regex if one is given' do
      result = Some["heliotrope"].match do |m|
        m.some(/banana split/) { "matched /banana split/" }
        m.some(/lio/)          { "matched /lio/" }
      end
      expect(result).to eq "matched /lio/"
    end

    it 'matches when a given predicate proc returns true, too' do
      result = Some[""].match do |m|
        m.some(~:nil?)   { "matched nil?"   }
        m.some(~:empty?) { "matched empty?" }
      end
      expect(result).to eq "matched empty?"
    end

    it 'provides the value of the some to the block for use' do
      result = Some[:foo].match do |m|
        m.some { |value| "The value was #{value}!" }
      end
      expect(result).to eq "The value was foo!"
    end

    it "does not match `None`" do
      expect do
        None.match do |m|
          m.some { "success" }
        end
      end.to raise_error BadMatchError
    end
  end

  describe '#none' do
    it 'matches `None`' do
      result = None.match do |m|
        m.some { "matches some" }
        m.none { "matches none" }
      end
      expect(result).to eq 'matches none'
    end

    it 'does not match `Some`' do
      expect do
        Some[:foo].match do |m|
          m.none { "success" }
        end
      end.to raise_error BadMatchError
    end
  end

  describe 'wildcard (underscore) match' do
    it 'matches `None`' do
      result = None.match do |m|
        m.some { "doesn't match"    }
        m._    { "matches anything" }
      end
      expect(result).to eq "matches anything"
    end

    it 'matches `Some`' do
      result = Some[:foo].match do |m|
        m.none { "doesn't match"    }
        m._    { "matches anything" }
      end
      expect(result).to eq "matches anything"
    end
  end
end
