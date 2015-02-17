module LambdaMoo
  class ScatterExpression < BinaryExpression
    def assign_expression(value, runtime)
      puts "** DEBUG: assign: scatter expression expr1=#{expr1.inspect} expr2=#{expr2.inspect} **"
      LambdaMoo::Integer.new(42)
    end

    def evaluate(runtime = nil)
      puts "** DEBUG: evaluate: scatter expression expr1=#{expr1.inspect} expr2=#{expr2.inspect} **"
      LambdaMoo::Integer.new(42)
    end
  end
end
