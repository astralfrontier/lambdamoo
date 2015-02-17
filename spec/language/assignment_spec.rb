require 'spec_helper'

describe LambdaMoo::VariableRef do
  let(:parser) { LambdaMoo::Parser.new }
  let(:runtime) { LambdaMoo::Runtime.new }

  it "should support assignment of a value" do
    expect(runtime).to receive(:set_variable).with("foo", LambdaMoo::Integer.new(42))
    parser.parse("foo = 42", rule: :expr).evaluate(runtime)
  end

  it "should return the value of the variable on assignment" do
    expect(runtime).to receive(:set_variable).and_return(LambdaMoo::Integer.new(42))
    result = parser.parse("foo = 42", rule: :expr).evaluate(runtime)
    expect(result.to_i).to eq 42
  end
end

describe LambdaMoo::AssignmentExpression do
  let(:parser) { LambdaMoo::Parser.new }
  let(:runtime) { LambdaMoo::Runtime.new }

  ["17", "#863", "\"Foo\"", "{1,2,3}", "E_INVARG"].each do |lvalue|
    it "should raise an exception assigning to lvalues such as #{lvalue}" do
      expect { parser.parse("#{lvalue} = 42", rule: :expr).evaluate(runtime) }.to raise_error(RuntimeError)
    end
  end

  it "should support assigning to variable lvalues" do
    expect(runtime).to receive(:set_variable).with("foo", LambdaMoo::Integer.new(42))
    expect { parser.parse("foo = 42", rule: :expr).evaluate(runtime) }.not_to raise_error
  end

  it "should support assigning to property lvalues" do
    expect(runtime).to receive(:set_property_value).with(LambdaMoo::ObjectNumber.new(0), LambdaMoo::String.new("foo"), LambdaMoo::Integer.new(42))
    expect { parser.parse("#0.foo = 42", rule: :expr).evaluate(runtime) }.not_to raise_error
  end
end
