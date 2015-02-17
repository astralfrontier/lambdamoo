module LambdaMoo
  class ForStatement < Struct.new(:id, :expr, :statements)
    def execute(runtime = nil)
      list = expr.evaluate(runtime)
      raise LambdaMoo::Exception.new("E_TYPE") unless list.kind_of? LambdaMoo::List
      list.value.each do |subexpr|
        id.assign_expression(subexpr.evaluate(runtime), runtime)
        statements.each do |statement|
          result = statement.execute(runtime)
          return result unless result.ok?
        end
      end
      StatementResult.ok
    end
  end
end
