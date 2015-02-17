module LambdaMoo
  class ComparisonExpression < BinaryExpression
    def evaluate(runtime = nil)
      v1 = expr1.evaluate(runtime)
      v2 = expr2.evaluate(runtime)
      LambdaMoo::Integer.new(evaluate_comparison(v1, v2) ? 1 : 0)
    end
  end

  class EqualsExpression < ComparisonExpression
    def evaluate_comparison(v1, v2)
      if v1.kind_of?(LambdaMoo::String) && v2.kind_of?(LambdaMoo::String)
        v1.value.downcase == v2.value.downcase
      elsif v1.kind_of?(LambdaMoo::List) && v2.kind_of?(LambdaMoo::List)
        if v1.value.size == v2.value.size
          v1.value.size.times.collect { |i|
            evaluate_comparison(v1.value[i], v2.value[i])
          }.all? { |a| a }
        else
          false
        end
      elsif (v1.kind_of?(LambdaMoo::Integer) && v2.kind_of?(LambdaMoo::Float)) ||
            (v1.kind_of?(LambdaMoo::Integer) && v2.kind_of?(LambdaMoo::Float))
        false # INT and FLOAT are never the same value
      else
        v1.value == v2.value
      end
    end
  end

  class NotEqualsExpression < ComparisonExpression
    def evaluate_comparison(v1, v2)
      if v1.kind_of?(LambdaMoo::String) && v2.kind_of?(LambdaMoo::String)
        v1.value.downcase != v2.value.downcase
      elsif v1.kind_of?(LambdaMoo::List) && v2.kind_of?(LambdaMoo::List)
        if v1.value.size == v2.value.size
          v1.value.size.times.collect { |i|
            evaluate_comparison(v1.value[i], v2.value[i])
          }.any? { |a| !a }
        else
          true
        end
      else
        v1.value != v2.value
      end
    end
  end
end
