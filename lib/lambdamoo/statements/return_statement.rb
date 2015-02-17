module LambdaMoo
  class ReturnStatement < Struct.new(:expr)
    def execute(runtime = nil)
      StatementResult.return(expr.evaluate(runtime))
    end
  end
end
