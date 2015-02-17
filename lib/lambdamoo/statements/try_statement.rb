require 'yaml'
module LambdaMoo
  class TryStatement < Struct.new(:try, :excepts, :finally)
    def execute(runtime = nil)
      begin
        try.each do |statement|
          result = statement.execute(runtime)
          return result unless result.ok?
        end
        return StatementResult.ok
      rescue LambdaMoo::Exception => exception
        excepts.each do |except|
          id, codes, statements = except
          if exception_matches_codes(exception, codes)
            id.assign_expression(LambdaMoo::Error.new(exception.message), runtime) unless id.nil?
            statements.each do |statement|
              result = statement.execute(runtime)
              return result unless result.ok?
            end
            return StatementResult.ok
          end
        end
        finally.each do |statement|
          result = statement.execute(runtime)
          # Can you even do this?
          return result unless result.ok?
        end
        raise
      end
    end

    def exception_matches_codes(exception, codes)
      m = exception.message.upcase
      codes.any? { |code| 
        c = code.value.upcase
        (c == 'ANY') || (c == m)
      }
    end
  end
end
