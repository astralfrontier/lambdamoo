module LambdaMoo
  class Exception < StandardError
    def initialize(error)
      super(error.to_s)
    end
  end

  # Literal values
  class LiteralValue < Struct.new(:value)
    def to_s; value.to_s; end
    def to_i; value.to_i; end
    def to_f; value.to_f; end
    def evaluate(runtime = nil); self; end
    def is_true?
      false
    end
  end

  class Integer < LiteralValue
    def is_true?
      value.to_i != 0
    end
  end

  class Float < LiteralValue
    def is_true?
      value.to_f != 0.0
    end
  end

  class String < LiteralValue
    def to_s
      "\"#{value.to_s}\""
    end

    def is_true?
      value.to_s != ""
    end
  end

  class ObjectNumber < LiteralValue
    def to_s
      "##{value}"
    end

    def is_true?
      false
    end
  end

  class Error < LiteralValue
    def is_true?
      false
    end
  end

  class List < LiteralValue
    def evaluate(runtime = nil)
      LambdaMoo::List.new(value.collect { |e| e.evaluate(nil) })
    end

    def to_a
      value
    end

    def to_s
      "{#{value.collect { |e| e.to_s }.join(", ")}}"
    end

    def is_true?
      value.size != 0
    end
  end

  # References
  class VariableRef < Struct.new(:id)
    def evaluate(runtime = nil)
      raise LambdaMoo::Exception.new("E_NONE") if runtime.nil?
      runtime.get_variable(id)
    end

    def assign_expression(value, runtime)
      raise LambdaMoo::Exception.new("E_NONE") if runtime.nil?
      runtime.set_variable(id, value)
    end

    def to_s
      id.to_s
    end
  end

  class PropertyRef < Struct.new(:object_number, :expr)
    def evaluate(runtime = nil)
      raise LambdaMoo::Exception.new("E_NONE") if runtime.nil?
      runtime.get_property_value(object_number, expr.evaluate(runtime))
    end

    def assign_expression(value, runtime)
      raise LambdaMoo::Exception.new("E_NONE") if runtime.nil?
      runtime.set_property_value(object_number, expr.evaluate(runtime), value.evaluate(runtime))
    end

    def to_s
      "#{object_number.to_s}.(#{expr.to_s})"
    end
  end

  # Expressions
  class UnaryExpression < Struct.new(:expr1); end

  class BinaryExpression < Struct.new(:expr1, :expr2); end

  class TernaryExpression < Struct.new(:expr1, :expr2, :expr3); end

  class AssignmentExpression < BinaryExpression
    def evaluate(runtime = nil)
      unless expr1.respond_to?(:assign_expression)
        raise "Illegal expression on left side of assignment."
      end
      value = expr2.evaluate(runtime)
      expr1.assign_expression(value, runtime)
      value
    end
  end

  class BuiltinFunctionExpression < Struct.new(:name, :arglist)
    def evaluate(runtime = nil)
      raise "Runtime cannot be nil" if runtime.nil?
      runtime.call_builtin_function(name, arglist.collect { |arg| arg.evaluate(runtime) })
    end
  end
end
