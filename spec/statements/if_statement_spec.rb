require 'spec_helper'

describe LambdaMoo::IfStatement do
  let(:parser) { LambdaMoo::Parser.new }
  let(:runtime) { LambdaMoo::Runtime.new }

  it "should be case-insensitive" do
    program = parser.parse("IF(0); ELSEIF(0); ELSE; ENDIF")
    program.execute(runtime)
  end

  it "should execute the statements in the IF clause" do
    expect(runtime).to receive(:call_builtin_function).with("foo", [])
    expect(runtime).to receive(:call_builtin_function).with("bar", [])
    expect(runtime).not_to receive(:call_builtin_function).with("baz", [])
    program = parser.parse("if(1); foo(); bar(); else; baz(); endif")
    program.execute(runtime)
  end

  it "should execute the statements in the ELSE clause" do
    expect(runtime).not_to receive(:call_builtin_function).with("foo", [])
    expect(runtime).not_to receive(:call_builtin_function).with("bar", [])
    expect(runtime).to receive(:call_builtin_function).with("baz", [])
    program = parser.parse("if(0); foo(); bar(); else; baz(); endif")
    program.execute(runtime)
  end

  it "should execute the statements in the ELSEIF clause" do
    expect(runtime).not_to receive(:call_builtin_function).with("foo", [])
    expect(runtime).to receive(:call_builtin_function).with("bar", [])
    expect(runtime).not_to receive(:call_builtin_function).with("baz", [])
    program = parser.parse("if(0); foo(); elseif(1); bar(); else; baz(); endif")
    program.execute(runtime)
  end

  it "should evaluate the expression in an IF clause only once" do
    expect(runtime).to receive(:call_builtin_function).with("foo", []).and_return(LambdaMoo::Integer.new(1))
    expect(runtime).to receive(:call_builtin_function).with("bar", [])
    program = parser.parse("if(foo()); bar(); endif")
    program.execute(runtime)
  end

  it "should not evaluate the expression in an ELSEIF clause if IF was true" do
    expect(runtime).to receive(:call_builtin_function).with("foo", []).and_return(LambdaMoo::Integer.new(1))
    expect(runtime).to receive(:call_builtin_function).with("bar", [])
    expect(runtime).not_to receive(:call_builtin_function).with("baz", [])
    expect(runtime).not_to receive(:call_builtin_function).with("bletch", [])
    program = parser.parse("if(foo()); bar(); elseif(baz()); bletch(); endif")
    program.execute(runtime)
  end
end
