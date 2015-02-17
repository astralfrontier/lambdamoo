module LambdaMoo
  class IfStatement < Struct.new(:ifs)
    def execute(runtime = nil)
      ifs.each do |expr,statements|
        matched = if expr.nil?
          true # else
        else
          evaled_value = expr.evaluate(runtime)
          evaled_value.respond_to?(:is_true?) && evaled_value.is_true?
        end
        if matched
          statements.each do |statement|
            result = statement.execute(runtime)
            return result unless result.ok?
          end
          break
        end
      end
      StatementResult.ok
    end
  end
end
