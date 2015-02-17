module LambdaMoo
  class StatementResult < Struct.new(:result, :value)
    # result can be one of:
    # :ok
    # :return (value is the value to return)
    # :break (value is the label name to break to)
    # :continue (value is the label name to continue to)

    # Helper functions for returning a given result
    def self.ok
      StatementResult.new(:ok, nil)
    end

    def self.return(value)
      StatementResult.new(:return, value)
    end

    def self.break(value = nil)
      StatementResult.new(:break, value)
    end

    def self.continue(value = nil)
      StatementResult.new(:continue, value)
    end

    def ok?
      result == :ok
    end

    def return?
      result == :return
    end
  end
end
