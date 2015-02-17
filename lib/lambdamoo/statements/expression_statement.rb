module LambdaMoo
  class ExpressionStatement < Struct.new(:expr)
    # Evaluates an expression and drops the result on the floor
    def execute(runtime = nil)
      expr.evaluate(runtime)
      StatementResult.ok
    end
  end
end
