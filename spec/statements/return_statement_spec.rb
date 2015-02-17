require 'spec_helper'

describe LambdaMoo::ReturnStatement do
  let(:parser) { LambdaMoo::Parser.new }
  let(:runtime) { LambdaMoo::Runtime.new }

  it "should be case-insensitive" do
    program = parser.parse("RETURN;")
    program.execute(runtime)
  end

  it "should halt execution of the current program" do
    expect(runtime).not_to receive(:call_builtin_function)
    program = parser.parse("return 42; test_builtin();")
    program.execute(runtime)
  end
end
