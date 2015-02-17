require 'spec_helper'

describe LambdaMoo::InListExpression do
  let(:list) { LambdaMoo::List.new([
    LambdaMoo::Integer.new(123),
    LambdaMoo::String.new("Foo"),
    LambdaMoo::Integer.new(123)
  ]) }
  let(:integer) { LambdaMoo::Integer.new(42) }

  it "should raise E_TYPE if expression-2 isn't a list" do
    expect { LambdaMoo::InListExpression.new(list, integer).evaluate(nil) }.to raise_error(LambdaMoo::Exception, "E_TYPE")
  end

  it "should return the 1-based index of the first occurrence of the value" do
    value = LambdaMoo::Integer.new(123)
    expect(LambdaMoo::InListExpression.new(value, list).evaluate(nil).value).to eq 1
  end

  it "should return 0 if the value was not found" do
    value = LambdaMoo::Integer.new(456)
    expect(LambdaMoo::InListExpression.new(value, list).evaluate(nil).value).to eq 0
  end

  it "should perform string searches" do
    value = LambdaMoo::String.new("Foo")
    expect(LambdaMoo::InListExpression.new(value, list).evaluate(nil).value).to eq 2
  end

  it "should perform case-insensitive string searches" do
    value = LambdaMoo::String.new("foo")
    expect(LambdaMoo::InListExpression.new(value, list).evaluate(nil).value).to eq 2
  end
end
