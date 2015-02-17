module LambdaMoo
  class Variable < Struct.new(:name, :value); end

  class Runtime
    def initialize
      @variables = {}
      @notifies = []

      ["INT", "FLOAT", "OBJ", "STR", "LIST", "ERR", "NUM"].each do |var|
        @variables[var] = 0
      end

      @variables["args"] = LambdaMoo::List.new([])
      ["player", "this", "caller", "dobj", "iobj"].each do |var|
        @variables[var] = LambdaMoo::ObjectNumber.new(0)
      end
      ["verb", "argstr", "dobjstr", "prepstr", "iobjstr"].each do |var|
        @variables[var] = LambdaMoo::String.new("")
      end
    end

    def call_builtin_function(name, arglist)
      bf_method = "bf_#{name.downcase}"
      if respond_to? bf_method
        send(bf_method, arglist)
      else
        raise LambdaMoo::Exception.new("E_NONE")
      end
    end

    def get_variable(name)
      @variables[name.downcase].clone
    end

    def set_variable(name, value)
      @variables[name.downcase] = value
    end

    def get_property_value(object_number, name)
      raise LambdaMoo::Exception.new("E_NONE")
    end

    def set_property_value(object_number, name, value)
      raise LambdaMoo::Exception.new("E_NONE")
    end

    def call_verb(object_number, name, arglist)
      raise LambdaMoo::Exception.new("E_NONE")
    end

    def bf_notify(args)
      who, what = args
      msg = "#{who.to_s} -> #{what}"
      @notifies << msg
      puts msg
      LambdaMoo::Integer.new(0)
    end
  end
end
