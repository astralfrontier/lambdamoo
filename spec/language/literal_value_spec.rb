require 'spec_helper'

describe LambdaMoo::Integer do
  subject(:int) { LambdaMoo::Integer.new(42) }

  describe "#evaluate" do
    it "should return itself" do
      expect(int.evaluate).to eq int
    end
  end

  describe "#to_i" do
    it "should return the integer value" do
      expect(int.to_i).to eq 42
    end
  end

  describe "#to_s" do
    it "should return a string value" do
      expect(int.to_s).to eq "42"
    end
  end

  describe "#is_true?" do
    it "should be true for all integers other than zero" do
      expect(LambdaMoo::Integer.new(1).is_true?).to eq true
      expect(LambdaMoo::Integer.new(-1).is_true?).to eq true
    end

    it "should be false for the integer zero" do
      expect(LambdaMoo::Integer.new(0).is_true?).to eq false
    end
  end
end

describe LambdaMoo::Float do
  subject(:float) { LambdaMoo::Float.new(42.0) }

  describe "#evaluate" do
    it "should return itself" do
      expect(float.evaluate).to eq float
    end
  end

  describe "#to_f" do
    it "should return the float value" do
      expect(float.to_f).to eq 42.0
    end
  end

  describe "#to_s" do
    it "should return a string value" do
      expect(float.to_s).to eq "42.0"
    end
  end

  describe "#is_true?" do
    it "should be true for all floats other than 0.0" do
      expect(LambdaMoo::Float.new(1.0).is_true?).to eq true
      expect(LambdaMoo::Float.new(-1.0).is_true?).to eq true
    end

    it "should be false for the floating-point numbers 0.0 and -0.0" do
      expect(LambdaMoo::Float.new(0.0).is_true?).to eq false
      expect(LambdaMoo::Float.new(-0.0).is_true?).to eq false
    end
  end
end

describe LambdaMoo::String do
  subject(:string) { LambdaMoo::String.new("foo") }

  describe "#evaluate" do
    it "should return itself" do
      expect(string.evaluate).to eq string
    end
  end

  describe "#to_s" do
    it "should return a string value" do
      expect(string.to_s).to eq "\"foo\""
    end
  end

  describe "#is_true?" do
    it "should be true for all non-empty strings" do
      expect(LambdaMoo::String.new("foo").is_true?).to eq true
    end

    it "should be false for the empty string" do
      expect(LambdaMoo::String.new("").is_true?).to eq false
    end
  end
end

describe LambdaMoo::ObjectNumber do
  subject(:object_ref) { LambdaMoo::ObjectNumber.new(42) }

  describe "#evaluate" do
    it "should return itself" do
      expect(object_ref.evaluate).to eq object_ref
    end
  end

  describe "#to_s" do
    it "should return a string value" do
      expect(object_ref.to_s).to eq "#42"
    end
  end

  describe "#is_true?" do
    it "should be false for all object numbers" do
      expect(LambdaMoo::ObjectNumber.new(0).is_true?).to eq false
      expect(LambdaMoo::ObjectNumber.new(1).is_true?).to eq false
    end
  end
end

describe LambdaMoo::Error do
  subject(:error) { LambdaMoo::Error.new("E_UNITTEST") }

  describe "#evaluate" do
    it "should return itself" do
      expect(error.evaluate).to eq error
    end
  end

  describe "#to_s" do
    it "should return a string value" do
      expect(error.to_s).to eq "E_UNITTEST"
    end
  end

  describe "#is_true?" do
    it "should be false for all errors" do
      expect(LambdaMoo::Error.new("E_DIV").is_true?).to eq false
    end
  end
end

describe LambdaMoo::List do
  subject(:list) { LambdaMoo::List.new([LambdaMoo::Integer.new(1), LambdaMoo::Integer.new(2), LambdaMoo::Integer.new(3)]) }

  describe "#evaluate" do
    it "should return a list with each element evaluated" do
      parser = LambdaMoo::Parser.new
      e = parser.parse("{3 + 4, 3 - 4, 3 * 4}", rule: :expr).evaluate(nil)
      expect(e.to_s).to eq "{7, -1, 12}"
    end
  end

  describe "#to_a" do
    it "should return an array" do
      a = list.to_a
      expect(a.size).to eq 3
      expect(a).to eq [1, 2, 3].collect { |i| LambdaMoo::Integer.new(i) }
    end
  end

  describe "#is_true?" do
    it "should be true for all non-empty lists" do
      expect(list.is_true?).to eq true
    end

    it "should be false for the empty list" do
      expect(LambdaMoo::List.new([]).is_true?).to be false
    end
  end
end
