require 'spec_helper'

describe LambdaMoo::Program do
  let(:parser) { LambdaMoo::Parser.new }
  let(:runtime) { LambdaMoo::Runtime.new }

  it "should execute statements in order" do
    expect(runtime).to receive(:call_builtin_function).with("foo", [])
    expect(runtime).to receive(:call_builtin_function).with("bar", [])
    program = parser.parse("foo(); bar();")
    program.execute(runtime)
  end
end
