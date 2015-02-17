module LambdaMoo
  class ArithmeticExpression < BinaryExpression
    def evaluate(runtime = nil)
      v1 = expr1.evaluate(runtime)
      v2 = expr2.evaluate(runtime)
      # Unless both operands to an arithmetic operator are
      # numbers of the same kind (or, for `+', both strings),
      # the error value E_TYPE is raised.
      evaluate_arithmetic(v1, v2)
    end
  end

  class AddExpression < ArithmeticExpression
    def evaluate_arithmetic(v1, v2)
      if v1.kind_of?(LambdaMoo::Integer) && v2.kind_of?(LambdaMoo::Integer)
        LambdaMoo::Integer.new(v1.to_i + v2.to_i)
      elsif v1.kind_of?(LambdaMoo::Float) && v2.kind_of?(LambdaMoo::Float)
        LambdaMoo::Float.new(v1.to_f + v2.to_f)
      elsif v1.kind_of?(LambdaMoo::String) && v2.kind_of?(LambdaMoo::String)
        LambdaMoo::String.new(v1.value + v2.value)
      else
        raise LambdaMoo::Exception.new("E_TYPE")
      end
    end
  end

  class SubtractExpression < ArithmeticExpression
    def evaluate_arithmetic(v1, v2)
      if v1.kind_of?(LambdaMoo::Integer) && v2.kind_of?(LambdaMoo::Integer)
        LambdaMoo::Integer.new(v1.to_i - v2.to_i)
      elsif v1.kind_of?(LambdaMoo::Float) && v2.kind_of?(LambdaMoo::Float)
        LambdaMoo::Float.new(v1.to_f - v2.to_f)
      else
        raise LambdaMoo::Exception.new("E_TYPE")
      end
    end
  end

  class MultiplyExpression < ArithmeticExpression
    def evaluate_arithmetic(v1, v2)
      if v1.kind_of?(LambdaMoo::Integer) && v2.kind_of?(LambdaMoo::Integer)
        LambdaMoo::Integer.new(v1.to_i * v2.to_i)
      elsif v1.kind_of?(LambdaMoo::Float) && v2.kind_of?(LambdaMoo::Float)
        LambdaMoo::Float.new(v1.to_f * v2.to_f)
      else
        raise LambdaMoo::Exception.new("E_TYPE")
      end
    end
  end

  class DivideExpression < ArithmeticExpression
    def evaluate_arithmetic(v1, v2)
      if v1.kind_of?(LambdaMoo::Integer) && v2.kind_of?(LambdaMoo::Integer)
        raise LambdaMoo::Exception.new("E_DIV") if v2.to_i == 0
        LambdaMoo::Integer.new(v1.to_i / v2.to_i)
      elsif v1.kind_of?(LambdaMoo::Float) && v2.kind_of?(LambdaMoo::Float)
        raise LambdaMoo::Exception.new("E_DIV") if v2.to_f == 0.0
        LambdaMoo::Float.new(v1.to_f / v2.to_f)
      else
        raise LambdaMoo::Exception.new("E_TYPE")
      end
    end
  end

  class RemainderExpression < ArithmeticExpression
    def evaluate_arithmetic(v1, v2)
      if v1.kind_of?(LambdaMoo::Integer) && v2.kind_of?(LambdaMoo::Integer)
        raise LambdaMoo::Exception.new("E_DIV") if v2.to_i == 0
        LambdaMoo::Integer.new(v1.to_i % v2.to_i)
      elsif v1.kind_of?(LambdaMoo::Float) && v2.kind_of?(LambdaMoo::Float)
        raise LambdaMoo::Exception.new("E_DIV") if v2.to_f == 0
        LambdaMoo::Float.new(v1.to_f % v2.to_f)
      else
        raise LambdaMoo::Exception.new("E_TYPE")
      end
    end
  end
end
