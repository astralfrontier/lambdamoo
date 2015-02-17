require 'spec_helper'

describe LambdaMoo::BuiltinFunctionExpression do
  let(:parser) { LambdaMoo::Parser.new }
  let(:runtime) { LambdaMoo::Runtime.new }

  it "should parse builtin functions" do
    e = parser.parse("bf_unittest(#123, 45)", rule: :expr)
    expect(e).to be_a LambdaMoo::BuiltinFunctionExpression
    expect(e.arglist.size).to eq 2
    expect(e.arglist[0]).to eq LambdaMoo::ObjectNumber.new(123)
    expect(e.arglist[1]).to eq LambdaMoo::Integer.new(45)
  end

  it "should call #builtin_function when evaluated" do
    arglist = [LambdaMoo::ObjectNumber.new(123), LambdaMoo::Integer.new(45)]
    e = parser.parse("bf_unittest(#123, 45)", rule: :expr)
    expect(runtime).to receive(:call_builtin_function).with("bf_unittest", arglist)
    e.evaluate(runtime)
  end
end
