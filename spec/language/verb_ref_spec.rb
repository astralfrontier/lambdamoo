require 'spec_helper'

describe LambdaMoo::VerbRef do
  let(:parser) { LambdaMoo::Parser.new }
  let(:runtime) { LambdaMoo::Runtime.new }

  it "should call LambdaMoo::Runtime#call_verb" do
    expect(runtime).to receive(:call_verb).with(LambdaMoo::ObjectNumber.new(123), LambdaMoo::String.new("foo"), [LambdaMoo::String.new("bar")])
    parser.parse("#123:foo(\"bar\")", rule: :expr).evaluate(runtime)
  end
end
