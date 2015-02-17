module LambdaMoo
  class Program < Struct.new(:statements)
    def execute(runtime = nil)
      statements.each do |statement|
        result = statement.execute(runtime)
        return result unless result.ok?
      end
      StatementResult.return(LambdaMoo::Integer.new(0))
    end
  end
end
