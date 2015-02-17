module LambdaMoo
  class NullStatement
    # Does nothing
    def execute(runtime = nil)
      StatementResult.ok
    end
  end
end
