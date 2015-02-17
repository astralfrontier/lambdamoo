require 'spec_helper'

describe LambdaMoo::ArithmeticExpression do
  let(:parser) { LambdaMoo::Parser.new }

  def calculate(problem, expected_type, solution)
    e = parser.parse(problem, rule: :expr).evaluate(nil)
    case expected_type
      when "INT"
        expect(e).to be_a LambdaMoo::Integer
        expect(e.to_i).to eq solution
      when "FLOAT"
        expect(e).to be_a LambdaMoo::Float
        expect(e.to_f).to eq solution
      when "STR"
        expect(e).to be_a LambdaMoo::String
        expect(e.value).to eq solution
    end
  end

  it "should give a correct answer for 5 + 2" do
    calculate("5 + 2", "INT", 7)
  end

  it "should give a correct answer for 5 - 2" do
    calculate("5 - 2", "INT", 3)
  end

  it "should give a correct answer for 5 * 2" do
    calculate("5 * 2", "INT", 10)
  end

  it "should give a correct answer for 5 / 2" do
    calculate("5 / 2", "INT", 2)
  end

  it "should give a correct answer for 5.0 / 2.0" do
    calculate("5.0 / 2.0", "FLOAT", 2.5)
  end

  it "should give a correct answer for 5 % 2" do
    calculate("5 % 2", "INT", 1)
  end

  it "should give a correct answer for 5.0 % 2.0" do
    calculate("5.0 % 2.0", "FLOAT", 1.0)
  end

  xit "should give a correct answer for 5 % -2" do
    calculate("5 % -2", "INT", 1)
  end

  xit "should give a correct answer for -5 % 2" do
    calculate("-5 % 2", "INT", -1)
  end

  xit "should give a correct answer for -5 % -2" do
    calculate("-5 % -2", "INT", -1)
  end

  xit "should give a correct answer for -(5 + 2)" do
    calculate("-(5 + 2)", "INT", -7)
  end

  it "should give a correct answer for \"foo\" + \"bar\"" do
    calculate("\"foo\" + \"bar\"", "STR", "foobar")
  end

  it "should raise an exception for 1+1.0" do
    expect {
      parser.parse("1+1.0", rule: :expr).evaluate(nil)
    }.to raise_error(LambdaMoo::Exception, "E_TYPE")
  end

  it "should raise an exception for 1/0" do
    expect {
      parser.parse("1/0", rule: :expr).evaluate(nil)
    }.to raise_error(LambdaMoo::Exception, "E_DIV")
  end

  it "should raise an exception for 1.0/0.0" do
    expect {
      parser.parse("1.0/0.0", rule: :expr).evaluate(nil)
    }.to raise_error(LambdaMoo::Exception, "E_DIV")
  end
end
