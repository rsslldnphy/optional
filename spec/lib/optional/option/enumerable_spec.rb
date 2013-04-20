require 'spec_helper'

describe Option::Enumerable do

  let (:cat) { Cat.new("MOGGIE!") }

  describe "#do" do
    it "allows ops with side effects to be performed using the value as part of a method chain" do
      names = ""
      Some[cat].do { |c| names << c.name }.map(&:name).should eq Some["MOGGIE!"]
      names.should eq "MOGGIE!"
    end
  end

  describe "#map" do

    it "maps a some to a some" do
      Some[cat].map(&:name).should eq Some["MOGGIE!"]
    end

    it "also works for collect" do
      Some[cat].collect(&:name).should eq Some["MOGGIE!"]
    end

    it "also works for flat_map" do
      Some[cat].flat_map(&:name).should eq Some["MOGGIE!"]
    end

    it "maps none to none" do
      None.map(&:name).should be_none
    end

    it "also works for collect" do
      None.collect(&:name).should be_none
    end

    it "also works for flat_map" do
      None.flat_map(&:name).should be_none
    end

    it "also works for collect_concat" do
      None.collect_concat(&:name).should be_none
    end
  end

  describe "#detect" do
    it "returns none if called on a none" do
      None.detect{ |pet| pet.name == "MOGGIE!" }.should be_none
    end

    it "returns a some if called on a some that matches" do
      Some[cat].detect{ |pet| pet.name == "MOGGIE!" }.should eq Some[cat]
    end

    it "returns a none if called on a some that doesn't match" do
      Some[cat].detect{ |pet| pet.name == "DOGGIE!" }.should be_none
    end

    it "also works for find" do
      None.find{ |pet| pet.name == "MOGGIE!" }.should be_none
      Some[cat].find{ |pet| pet.name == "MOGGIE!" }.should eq Some[cat]
      Some[cat].find{ |pet| pet.name == "DOGGIE!" }.should be_none
    end

  end

  describe "#select" do

    it "returns a none if called on a none" do
      None.select(&:even?).should be_none
    end

    it "returns a none if called on a some that doesn't match" do
      Some[3].select(&:even?).should be_none
    end

    it "returns a some if called on a some that matches" do
      Some[3].select(&:odd?).should eq Some[3]
    end

    it "also works for find_all" do
      None.find_all(&:even?).should be_none
      Some[3].find_all(&:even?).should be_none
      Some[3].find_all(&:odd?).should eq Some[3]
    end

  end

  describe "#grep" do
    it "returns a none if no matching elements" do
      None.grep(/ing/).should be_none
    end

    it "returns a some otherwise" do
      Some["finger"].grep(/ing/).should eq Some["finger"]
    end
  end

  describe "#reduce" do
    it "raises an error if it is called on None" do
      expect { None.reduce(:+) }.to raise_error Option::ValueOfNoneError
      expect { None.reduce{ |acc, x| acc + x } }.to raise_error Option::ValueOfNoneError
    end

    it "works with a none as expected otherwise" do
      None.reduce(5, :+).should eq 5
      None.reduce(5) { |acc, x| acc + x }.should eq 5
    end

    it "works with a some as expected" do
      Some[4].reduce(:+).should eq 4
      Some[4].reduce(5, :+).should eq 9
      Some[4].reduce(5) { |acc, x| acc + x }.should eq 9
    end

    it "also works as inject" do
      Some[4].inject(:+).should eq 4
    end
  end

  describe "#none?" do
    it "returns true if given a block the block evaluates to false for the value" do
      Some[6].none?(&:odd?).should be_true
    end
  end

  describe "#reject" do
    it "returns either some or none" do
      None.reject(&:odd?).should be_none
      Some[3].reject(&:odd?).should be_none
      Some[4].reject(&:odd?).should eq Some[4]
    end
  end
end
