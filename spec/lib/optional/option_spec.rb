require 'spec_helper'

describe Option do

  let (:cat) { Cat.new("MOGGIE!") }
  let (:dog) { Dog.new("DOGGIE!") }

  context "== pattern matching ==" do

    subject do
      option.match do |m|
        m.some { |cat| cat.name }
        m.none { "no cat :-(" }
      end
    end

    context "a match can have one None branch, which matches only None" do
      let (:option) { None }
      it { should eq "no cat :-(" }
    end

    context "a match can have a catchall Some branch which matches any Some" do
      let (:option) { Some[cat] }
      it { should eq "MOGGIE!" }
    end

    it "can have multiple Some branches, each one matching a value" do
      Some[cat].match do |m|
        m.some(dog) { :canteloupe }
        m.some(cat) { :fishsticks }
      end.should eq :fishsticks
    end

    it "can take a lambda as a guard to match against" do
      Some[cat].match do |m|
        m.some ->(pet) { pet.name == "DOGGIE!" } { :fishsticks }
        m.some ->(pet) { pet.name == "MOGGIE!" } { :canteloupe }
      end.should eq :canteloupe
    end
  end

end
