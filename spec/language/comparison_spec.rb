require 'spec_helper'

describe LambdaMoo::ComparisonExpression do
  let(:parser) { LambdaMoo::Parser.new }

  def compare(problem, solution)
    e = parser.parse(problem, rule: :expr).evaluate(nil)
    expect(e.value).to eq solution
  end

  it "should be false for 3 == 4" do
    compare("3 == 4", 0)
  end

  it "should be true for 3 != 4" do
    compare("3 != 4", 1)
  end

  it "should be false for 3 == 3.0" do
    compare("3 == 3.0", 0)
  end

  it "should be true for \"foo\" == \"Foo\"" do
    compare("\"foo\" == \"Foo\"", 1)
  end

  it "should be false for #34 != #34" do
    compare("#34 != #34", 0)
  end

  it "should be true for {1, #34, \"foo\"} == {1, #34, \"FoO\"}" do
    compare("{1, #34, \"foo\"} == {1, #34, \"FoO\"}", 1)
  end

  it "should be false for E_DIV == E_TYPE" do
    compare("E_DIV == E_TYPE", 0)
  end

  it "should be true for 3 != \"foo\"" do
    compare("3 != \"foo\"", 1)
  end

  xit "should be true for 3 < 4" do
    compare("3 < 4", 1)
  end

  xit "should raise E_TYPE for 3 < 4.0" do
    expect { parser.parse("3 < 4.0", rule: :expr).evaluate(nil) }.to raise_error(LambdaMoo::Exception, "E_TYPE")
  end

  xit "should be true for #34 >= #32" do
    compare("#34 > #32", 1)
  end

  xit "should be false for \"foo\" <= \"Boo\"" do
    compare("\"foo\" <= \"Boo\"", 0)
  end

  xit "should be true for E_DIV > E_TYPE" do
    compare("E_DIV > E_TYPE", 1)
  end
end
