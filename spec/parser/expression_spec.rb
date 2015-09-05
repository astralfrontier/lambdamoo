require 'spec_helper'

describe LambdaMoo::Parser do
  subject(:parser) { LambdaMoo::Parser.new }

  context "for expressions" do
    it "should parse an INT expression" do
      e = parser.parse("17", rule: :expr)
      expect(e).to be_a LambdaMoo::Integer
      expect(e.to_i).to eq 17
    end

    it "should parse an OBJ expression" do
      e = parser.parse("#893", rule: :expr)
      expect(e).to be_a LambdaMoo::ObjectNumber
      expect(e.to_s).to eq "#893"
      expect(e.to_i).to eq 893
    end

    it "should parse an OBJ with a negative value" do
      e = parser.parse("#-1", rule: :expr)
      expect(e).to be_a LambdaMoo::ObjectNumber
      expect(e.to_s).to eq "#-1"
      expect(e.to_i).to eq -1
    end

    it "should parse a STR expression" do
      e = parser.parse("\"foo\"", rule: :expr)
      expect(e).to be_a LambdaMoo::String
      expect(e.to_s).to eq "\"foo\""
    end

    it "should parse an empty string" do
      e = parser.parse("\"\"", rule: :expr)
      expect(e).to be_a LambdaMoo::String
      expect(e.to_s).to eq "\"\""
    end

    it "should parse a string containing quotation marks" do
      e = parser.parse('"foo \"bar baz"', rule: :expr)
      expect(e).to be_a LambdaMoo::String
      expect(e.to_s).to eq '"foo \"bar baz"'
    end

    # TODO: all errors
    ["E_DIV", "E_INVARG", "E_TYPE"].each do |err|
      it "should parse an ERR expression with the value E_INVARG" do
        e = parser.parse(err, rule: :expr)
        expect(e).to be_a LambdaMoo::Error
        expect(e.to_s).to eq err
      end
    end

    it "should parse a LIST expression" do
      e = parser.parse("{1, 2, 3}", rule: :expr)
      expect(e).to be_a LambdaMoo::List
      expect(e.to_a).to eq [1, 2, 3].collect { |i| LambdaMoo::Integer.new(i) }
    end
  end

  context "for references" do
    ["foo", "_foo", "this2that", "M68000", "two_words", "This_is_a_very_long_multiword_variable_name"].each do |var|
      it "should parse '#{var}' as a variable" do
        e = parser.parse(var, rule: :expr)
        expect(e).to be_a LambdaMoo::VariableRef
        expect(e.to_s).to eq var
      end
    end

    ["fubar", "Fubar", "FUBAR", "fUbAr"].each do |var|
      it "should parse '#{var}' as a variable" do
        e = parser.parse(var, rule: :expr)
        expect(e).to be_a LambdaMoo::VariableRef
        expect(e.to_s).to eq var
      end
    end

    it "should parse $foo as #0.foo" do
      e = parser.parse("$foo", rule: :expr)
      expect(e).to be_a LambdaMoo::PropertyRef
      expect(e.object_number.to_s).to eq "#0"
      expect(e.expr.value).to eq "foo"
    end
  end

  context "for verbs" do
    it "should parse core verb references" do
      e = parser.parse("$foo()", rule: :expr)
      expect(e).to be_a LambdaMoo::VerbRef
      expect(e.object_number.to_s).to eq "#0"
      expect(e.verb_name.value).to eq "foo"
      expect(e.arglist).to eq []
    end

    it "should parse normal verb references" do
      e = parser.parse("#123:foo()", rule: :expr)
      expect(e).to be_a LambdaMoo::VerbRef
      expect(e.object_number.to_s).to eq "#123"
      expect(e.verb_name.value).to eq "foo"
      expect(e.arglist).to eq []
    end

    it "should parse expression-based verb references" do
      e = parser.parse("#123:(\"foo\")()", rule: :expr)
      expect(e).to be_a LambdaMoo::VerbRef
      expect(e.object_number.to_s).to eq "#123"
      expect(e.verb_name.value).to eq "foo"
      expect(e.arglist).to eq []
    end
  end

  context "for operators" do
    it "should ignore whitespace" do
      e = parser.parse("2 + 2", rule: :expr)
      expect(e).to be_a LambdaMoo::BinaryExpression
    end
  end

  context "for lists" do
    it "should parse X in Y" do
      e = parser.parse("1 in {1,2,3}", rule: :expr)
      expect(e).to be_a LambdaMoo::InListExpression
    end
  end

  context "for parentheses" do
    it "should parse parenthesized expressions" do
      e = parser.parse("(42 + 42)", rule: :expr)
      expect(e.evaluate(nil).to_i).to eq 84
    end
  end

  context "for unary minus" do
    it "should negate expressions" do
      e = parser.parse("-(42 + 42)", rule: :expr)
      expect(e.evaluate(nil).to_i).to eq -84
    end

    it "should have precedence over arithmetic operations" do
      e = parser.parse("2 + -1", rule: :expr)
      expect(e.evaluate(nil).to_i).to eq 1
    end
  end
end
