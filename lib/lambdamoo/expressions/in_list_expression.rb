module LambdaMoo
  class InListExpression < BinaryExpression
    def evaluate(runtime = nil)
      v1 = expr1.evaluate(runtime)
      v2 = expr2.evaluate(runtime)
      raise LambdaMoo::Exception.new("E_TYPE") unless v2.kind_of?(LambdaMoo::List)
      # TODO: don't make this part of the expression code - pull it out into its own thing
      cmp = EqualsExpression.new(nil, nil)
      v2.value.each.with_index do |v2_item,i|
        if cmp.evaluate_comparison(v1, v2_item)
          return LambdaMoo::Integer.new(i+1)
        end
      end
      return LambdaMoo::Integer.new(0)
    end
  end
end

