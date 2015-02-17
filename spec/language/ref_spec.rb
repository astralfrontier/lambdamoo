require 'spec_helper'

describe LambdaMoo::VariableRef do
  subject(:id) { LambdaMoo::VariableRef.new("foo") }

  describe "#to_s" do
    it "should return a string value" do
      expect(id.to_s).to eq "foo"
    end
  end
end
