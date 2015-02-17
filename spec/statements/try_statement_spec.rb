require 'spec_helper'

describe LambdaMoo::TryStatement do
  let(:parser) { LambdaMoo::Parser.new }
  let(:runtime) { LambdaMoo::Runtime.new }

  it "should be case-insensitive for try-except" do
    program = parser.parse("TRY; 1; EXCEPT id (ANY); ENDTRY;")
    program.execute(runtime)
  end

  it "should be case-insensitive for try-finally" do
    program = parser.parse("TRY; 1; FINALLY; ENDTRY;")
    program.execute(runtime)
  end

  it "should execute the statements in the TRY clause" do
    expect(runtime).to receive(:call_builtin_function).with("foo", [])
    expect(runtime).not_to receive(:call_builtin_function).with("bar", [])
    program = parser.parse("try; foo(); except id (ANY); bar(); endtry")
    program.execute(runtime)
  end

  it "should execute the statements in the EXCEPT clause if the exception matches" do
    expect(runtime).to receive(:call_builtin_function).with("foo", []).and_raise(LambdaMoo::Exception.new("E_NONE"))
    expect(runtime).not_to receive(:call_builtin_function).with("bar", [])
    expect(runtime).to receive(:call_builtin_function).with("baz", [])
    program = parser.parse("try; foo(); except (E_INVARG); bar(); except (E_NONE) baz(); endtry;")
    program.execute(runtime)
  end

  it "should assign the exception to a variable in an EXCEPT clause" do
    expect(runtime).to receive(:call_builtin_function).with("foo", []).and_raise(LambdaMoo::Exception.new("E_NONE"))
    expect(runtime).to receive(:set_variable).with("id", LambdaMoo::Error.new("E_NONE"))
    expect(runtime).to receive(:call_builtin_function).with("bar", [])
    program = parser.parse("try; foo(); except id (E_NONE); bar(); endtry;")
    program.execute(runtime)
  end

  it "should execute the statements in the EXCEPT clause if the code is ANY" do
    expect(runtime).to receive(:call_builtin_function).with("foo", []).and_raise(LambdaMoo::Exception.new("E_NONE"))
    expect(runtime).not_to receive(:call_builtin_function).with("bar", [])
    expect(runtime).to receive(:call_builtin_function).with("baz", [])
    program = parser.parse("try; foo(); except (E_INVARG); bar(); except (ANY) baz(); endtry;")
    program.execute(runtime)
  end

  it "should execute the statements in the FINALLY clause" do
    expect(runtime).to receive(:call_builtin_function).with("foo", []).and_raise(LambdaMoo::Exception.new("E_NONE"))
    expect(runtime).to receive(:call_builtin_function).with("bar", [])
    program = parser.parse("try; foo(); finally; bar(); endtry")
    begin; program.execute(runtime); rescue; end
  end

  it "should not re-raise for EXCEPT" do
    expect(runtime).to receive(:call_builtin_function).with("foo", []).and_raise(LambdaMoo::Exception.new("E_NONE"))
    expect(runtime).to receive(:call_builtin_function).with("bar", [])
    program = parser.parse("try; foo(); except (E_NONE); bar(); endtry;")
    expect { program.execute(runtime) }.not_to raise_error
  end

  it "should re-raise for FINALLY" do
    expect(runtime).to receive(:call_builtin_function).with("foo", []).and_raise(LambdaMoo::Exception.new("E_NONE"))
    expect(runtime).to receive(:call_builtin_function).with("bar", [])
    program = parser.parse("try; foo(); finally; bar(); endtry")
    expect { program.execute(runtime) }.to raise_error(LambdaMoo::Exception, "E_NONE")
  end
end
