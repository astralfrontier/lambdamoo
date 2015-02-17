require 'spec_helper'

describe LambdaMoo::ForStatement do
  let(:parser) { LambdaMoo::Parser.new }
  let(:runtime) { LambdaMoo::Runtime.new }

  it "should be case-insensitive" do
    program = parser.parse("FOR x IN ({}); ENDFOR")
    program.execute(runtime)
  end

  it "should raise E_TYPE if the expression is not a list" do
    program = parser.parse("for x in (1); endfor")
    expect { program.execute(runtime) }.to raise_error(LambdaMoo::Exception, "E_TYPE")
  end

  it "should assign the variable each iteration of the loop" do
    [1, 2, 3].each do |i|
      expect(runtime).to receive(:set_variable).with("x", LambdaMoo::Integer.new(i))
    end
    program = parser.parse("for x in ({1,2,3}); endfor")
    program.execute(runtime)
  end

  it "should execute each statement in the loop" do
    expect(runtime).to receive(:set_variable).exactly(3).times
    expect(runtime).to receive(:call_builtin_function).with("foo", []).exactly(3).times
    expect(runtime).to receive(:call_builtin_function).with("bar", []).exactly(3).times
    program = parser.parse("for x in ({1,2,3}); foo(); bar(); endfor")
    program.execute(runtime)
  end

  it "should do nothing for an empty list" do
    expect(runtime).not_to receive(:set_variable)
    expect(runtime).not_to receive(:call_builtin_function)
    program = parser.parse("for x in ({}); foo(); bar(); endfor")
    program.execute(runtime)
  end
end
