require 'spec_helper'

describe LambdaMoo::WhileStatement do
  let(:parser) { LambdaMoo::Parser.new }
  let(:runtime) { LambdaMoo::Runtime.new }

  it "should be case-insensitive" do
    program = parser.parse("WHILE(0); ENDWHILE")
    program.execute(runtime)
  end

  it "should execute the statements in the WHILE clause" do
    expect(runtime).to receive(:call_builtin_function).with("foo", []).and_return(LambdaMoo::Integer.new(1))
    expect(runtime).to receive(:call_builtin_function).with("foo", []).and_return(LambdaMoo::Integer.new(0))
    expect(runtime).to receive(:call_builtin_function).with("bar", [])
    expect(runtime).to receive(:call_builtin_function).with("baz", [])
    program = parser.parse("while(foo()); bar(); baz(); endwhile")
    program.execute(runtime)
  end

  it "should not execute the statements in the WHILE clause if the expression is initially false" do
    expect(runtime).to receive(:call_builtin_function).with("foo", []).and_return(LambdaMoo::Integer.new(0))
    expect(runtime).not_to receive(:call_builtin_function).with("bar", [])
    expect(runtime).not_to receive(:call_builtin_function).with("baz", [])
    program = parser.parse("while(foo()); bar(); baz(); endwhile")
    program.execute(runtime)
  end
end
