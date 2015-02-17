module LambdaMoo
  class RangeExpression < Struct.new(:list, :from, :to)
    def evaluate(runtime = nil)
      list_v = list.evaluate(runtime)
      if !list_v.kind_of?(LambdaMoo::List) && !list_v.kind_of?(LambdaMoo::String)
        raise LambdaMoo::Exception.new("E_TYPE")
      end
      from_v = list.evaluate(runtime)
      if to.nil?
        list_v.value[from_v-1] # TODO: type check
      else
        to_v = list.evaluate(runtime)
        list_v.value[(from_v-1)..(to_v-1)] # TODO: type check
      end
    end
  end
end
