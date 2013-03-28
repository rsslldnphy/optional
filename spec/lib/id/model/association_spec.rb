require 'spec_helper'

describe Id::Model::Association do

  module Foo
    module Bar
      module Baz
        class Quux
        end
      end
    end
  end

  let (:model) { stub(name: "Foo::Bar::Baz::Quux") }
  let (:has_one) { Id::Model::Association.new(model, "yak", {}) }

  describe "hierarchy" do
    it "builds the class and module hierarchy for the model" do
      has_one.hierarchy.constants.should eq [
        Foo::Bar::Baz::Quux,
        Foo::Bar::Baz,
        Foo::Bar,
        Foo
      ]
    end
  end
end
