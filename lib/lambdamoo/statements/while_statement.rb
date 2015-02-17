module LambdaMoo
  class WhileStatement < Struct.new(:id, :expr, :statements)
    def execute(runtime = nil)
      while(check_truth(runtime))
        statements.each do |statement|
          result = statement.execute(runtime)
          # TODO: implement break/continue
          return result unless result.ok?
        end
      end
      StatementResult.ok
    end
  
    def check_truth(runtime)
      value = expr.evaluate(runtime)
      if value.nil?
        false # uh...
      else
        value.respond_to?(:is_true?) && value.is_true?
      end
    end
  end
end
