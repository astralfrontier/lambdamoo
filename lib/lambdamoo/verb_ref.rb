module LambdaMoo
  class VerbRef < Struct.new(:object_number, :verb_name, :arglist)
    def evaluate(runtime = nil)
      o = object_number.evaluate(runtime)
      v = verb_name.evaluate(runtime)
      runtime.call_verb(o, v, arglist)
    end
  end
end
