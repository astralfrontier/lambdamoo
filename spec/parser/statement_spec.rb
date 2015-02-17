require 'spec_helper'

describe LambdaMoo::Parser do
  subject(:parser) { LambdaMoo::Parser.new }

  context "for null statements" do
    it "should parse a null statement" do
      e = parser.parse(";", rule: :statement)
      expect(e).to be_a LambdaMoo::NullStatement
    end
  end

  context "for expression statements" do
    it "should parse an expression statement" do
      e = parser.parse("42;", rule: :statement)
      expect(e).to be_a LambdaMoo::ExpressionStatement
    end

    it "should call #evaluate on the expression when executed" do
      runtime = Object.new # make something up
      expect_any_instance_of(LambdaMoo::Integer).to receive(:evaluate).with(runtime)
      e = parser.parse("42;", rule: :statement)
      e.execute(runtime)
    end
  end
end
