require 'whittle'

module LambdaMoo
  class Parser < Whittle::Parser
    SYSTEM_OBJ = LambdaMoo::ObjectNumber.new(0)

    # Ignore whitespace
    rule(:whitespace => /\s+/).skip!

    rule :program do |r|
      r[:statements].as                           { |statements| LambdaMoo::Program.new(statements) }
    end

    rule :statements do |r|
      r[].as                                      { [] }
      r[:statements, :statement].as               { |statements,statement| [*statements, statement] }
      r[:statement].as                            { |statement| [statement] }
    end

    rule :statement do |r|
      r['if','(', :expr, ')', :statements, :elseifs, :elsepart, 'endif'].as {
        |_,_,expr,_,statements,elseifs,elsepart,_|
        LambdaMoo::IfStatement.new([[expr,statements], *(elseifs || []), (elsepart || [])])
      }
      r['for', :t_id, 'in', '(', :expr, ')', :statements, 'endfor'].as {
        |_,id,_,_,expr,_,statements,_|
        LambdaMoo::ForStatement.new(LambdaMoo::VariableRef.new(id.to_s), expr, statements)
      }
      r['for', :t_id, 'in', '[', :expr, '..', :expr, ']', :statements, 'endfor'].as { LambdaMoo::StubStatement.new }
      r['while', '(', :expr, ')', :statements, 'endwhile'].as {
        |_,_,expr,_,statements,_|
        LambdaMoo::WhileStatement.new(nil, expr, statements)
      }
      r['while', :t_id, '(', :expr, ')', :statements, 'endwhile'].as {
        |_,id,_,expr,_,statements,_|
        LambdaMoo::WhileStatement.new(id, expr, statements)
      }
      r['fork', '(', :expr, ')', :statements, 'endfork'].as { LambdaMoo::StubStatement.new }
      r['fork', :t_id, '(', :expr, ')', :statements, 'endfork'].as { LambdaMoo::StubStatement.new }
      r[:expr, ';'].as                            { |expr, _| LambdaMoo::ExpressionStatement.new(expr) }
      r['break', ';'].as { LambdaMoo::StubStatement.new }
      r['break', :t_id, ';'].as { LambdaMoo::StubStatement.new }
      r['continue', ';'].as { LambdaMoo::StubStatement.new }
      r['continue', :t_id, ';'].as { LambdaMoo::StubStatement.new }
      r['return', :expr, ';'].as                  { |_,expr,_| LambdaMoo::ReturnStatement.new(expr) }
      r['return', ';'].as                         { |_,_| LambdaMoo::ReturnStatement.new(LambdaMoo::Integer.new(0)) }
      r[';'].as                                   { |_| LambdaMoo::NullStatement.new }
      r['try', :statements, :excepts, 'endtry'].as {
        |_,statements,excepts,_|
        LambdaMoo::TryStatement.new(statements, excepts, [])
      }
      r['try', :statements, 'finally', :statements, 'endtry'].as {
        |_,statements,_,finally,_|
        LambdaMoo::TryStatement.new(statements, [], finally)
      }
    end

    rule :elseifs do |r|
      r[]
      r[:elseifs, 'elseif', '(', :expr, ')', :statements].as { |elseifs,_,_,expr,_,statements| (elseifs || []) + [[expr,statements]] }
    end

    rule :elsepart do |r|
      r[].as                                      { [nil, []] }
      r['else', :statements].as                   { |_,statements| [nil, statements] }
    end

    rule :excepts do |r|
      r['except', :except].as                     { |_,except| [except] }
      r[:excepts, 'except', :except].as           { |excepts,_,except| excepts + [except] }
    end

    rule :except do |r|
      r[:opt_id, '(', :codes, ')', :statements].as { |id,_,codes,_,statements| [id, codes, statements] }
    end

    rule :opt_id do |r|
      r[].as                                      { nil }
      r[:t_id].as                                 { |id| LambdaMoo::VariableRef.new(id) }
    end

    rule :expr do |r|
      r[:t_object].as                             { |value| LambdaMoo::ObjectNumber.new(value[1..-1].to_i) }
      r[:t_float].as                              { |value| LambdaMoo::Float.new(value.to_f) }
      r[:t_integer].as                            { |value| LambdaMoo::Integer.new(value.to_i) }
      r[:t_string].as                             { |value| LambdaMoo::String.new(value.to_s[1..-2]) }
      r[:t_error].as                              { |value| LambdaMoo::Error.new(value.to_s) }
      r['$', :t_id].as                            { |_,id| LambdaMoo::PropertyRef.new(SYSTEM_OBJ, LambdaMoo::String.new(id.to_s)) }
      r[:t_id].as                                 { |id| LambdaMoo::VariableRef.new(id.to_s) }
      r[:expr, '.', :t_id].as                     { |a,_,b| LambdaMoo::PropertyRef.new(a, LambdaMoo::String.new(b)) }
      r[:expr, '.', '(', :expr, ')'].as           { |a,_,_,b,_| LambdaMoo::PropertyRef.new(a, b) }
      r[:expr, ':', :t_id, '(', :arglist, ')'].as { |a,_,b,_,c,_| LambdaMoo::VerbRef.new(a, LambdaMoo::String.new(b), c) }
      r['$', :t_id, '(', :arglist, ')'].as        { |_,a,_,b,_| LambdaMoo::VerbRef.new(SYSTEM_OBJ, LambdaMoo::String.new(a), b) }
      r[:expr, ':', '(', :expr, ')', '(', :arglist, ')'].as { |a,_,_,b,_,_,c,_| LambdaMoo::VerbRef.new(a, b, c) }
      r[:expr, '[', :expr, ']'].as                { |a,b| LambdaMoo::RangeExpression.new(a, b, nil) }
      r[:expr, '[', :expr, '..', :expr, ']'].as   { |a,b,c| LambdaMoo::RangeExpression.new(a, b, c) }
      r[:expr, '=', :expr].as                     { |a,_,b| LambdaMoo::AssignmentExpression.new(a, b) }
      r['{', :scatter, '}', '=', :expr].as        { |_,a,_,_,b| LambdaMoo::ScatterExpression.new(a, b) }
      r[:t_id, '(', :arglist, ')'].as             { |a, _, b| LambdaMoo::BuiltinFunctionExpression.new(a, b) }
      r[:expr, '+', :expr].as                     { |a, _, b| LambdaMoo::AddExpression.new(a, b) }
      r[:expr, '-', :expr].as                     { |a, _, b| LambdaMoo::SubtractExpression.new(a, b) }
      r[:expr, '*', :expr].as                     { |a, _, b| LambdaMoo::MultiplyExpression.new(a, b) }
      r[:expr, '/', :expr].as                     { |a, _, b| LambdaMoo::DivideExpression.new(a, b) }
      r[:expr, '%', :expr].as                     { |a, _, b| LambdaMoo::RemainderExpression.new(a, b) }
      r[:expr, '^', :expr].as                     { |a, _, b| LambdaMoo::BinaryExpression.new(a, b) }
      r[:expr, '&&', :expr].as                    { |a, _, b| LambdaMoo::BinaryExpression.new(a, b) }
      r[:expr, '||', :expr].as                    { |a, _, b| LambdaMoo::BinaryExpression.new(a, b) }
      r[:expr, '==', :expr].as                    { |a, _, b| LambdaMoo::EqualsExpression.new(a, b) }
      r[:expr, '!=', :expr].as                    { |a, _, b| LambdaMoo::NotEqualsExpression.new(a, b) }
      r[:expr, '<', :expr].as                     { |a, _, b| LambdaMoo::BinaryExpression.new(a, b) }
      r[:expr, '<=', :expr].as                    { |a, _, b| LambdaMoo::BinaryExpression.new(a, b) }
      r[:expr, '>', :expr].as                     { |a, _, b| LambdaMoo::BinaryExpression.new(a, b) }
      r[:expr, '>=', :expr].as                    { |a, _, b| LambdaMoo::BinaryExpression.new(a, b) }
      r[:expr, "in", :expr].as                    { |a, _, b| LambdaMoo::InListExpression.new(a, b) }
      r['-', :expr].as                            {
        |_,a|
        LambdaMoo::SubtractExpression.new(LambdaMoo::Integer.new(0), a)
      } % :left ^ 1
      r['!', :expr].as                            { |_, a| LambdaMoo::UnaryExpression.new(a) }
      r['$'].as                                   { |_| LambdaMoo::EndOfListExpression.new }
      r['(', :expr, ')'].as                       { |_, a, _| a }
      r['{', :arglist, '}'].as                    { |_, a, _| LambdaMoo::List.new(a || []) }
      r[:expr, '?', :expr, '|', :expr].as         { |a, _, b, _, c| LambdaMoo::TernaryExpression.new(a, b, c) }
      r['`', :expr, '!', :codes, :default, '\''].as {
        |_,expr,_,codes,default,_|
        LambdaMoo::TernaryExpression.new(expr,codes,default)
      } # TODO
    end

    rule :default do |r|
      r[].as { nil }
      r['=>', :expr].as { |_,expr| expr }
    end

    rule :scatter do |r|
      r[:ne_arglist, ',', :scatter_item]
      r[:scatter, ',', :scatter_item]
      r[:scatter, ',', :t_id]
      r[:scatter, ',', '@', :t_id]
      r[:scatter_item]
    end

    rule :scatter_item do |r|
      r['?', :t_id]
      r['?', :t_id, '=', :expr]
    end

    rule :codes do |r|
      r['any'].as                                 { [LambdaMoo::Error.new("ANY")] }
      r[:ne_arglist].as                           { |arglist| arglist }
    end

    rule :arglist do |r|
      r[].as                                      { [] }
      r[:ne_arglist]
    end

    rule :ne_arglist do |r|
      r[:expr].as                                 { |a| [a] }
      r['@', :expr].as                            { |_, a| a.to_a }
      r[:ne_arglist, ',', :expr].as               { |a, _, b| a + [b] }
      r[:ne_arglist, ',', '@', :expr].as          { |a, _, _, b| a + b.to_a }
    end

    rule "if" => /if/i
    rule "elseif" => /elseif/i
    rule "else" => /else/i
    rule "endif" => /endif/i
    rule "for" => /for/i
    rule "endfor" => /endfor/i
    rule "while" => /while/i
    rule "endwhile" => /endwhile/i
    rule "return" => /return/i
    rule "try" => /try/i
    rule "except" => /except/i
    rule "finally" => /finally/i
    rule "endtry" => /endtry/i
    rule "any" => /any/i
    rule "fork" => /fork/i
    rule "endfork" => /endfork/i
    rule "break" => /break/i
    rule "continue" => /continue/i

    rule("!") % :left ^ 1
    rule("^") % :right ^2
    rule("*") % :left ^ 3
    rule("/") % :left ^ 3
    rule("%") % :left ^ 3
    rule("+") % :left ^ 4
    rule("-") % :left ^ 4
    rule("==") % :left ^ 5
    rule("!=") % :left ^ 5
    rule("!=") % :left ^ 5
    rule("<") % :left ^ 5
    rule("<=") % :left ^ 5
    rule(">") % :left ^ 5
    rule(">=") % :left ^ 5
    rule("in" => /in/i) % :left ^ 5
    rule("&&") % :left ^ 6
    rule("||") % :left ^ 6
    rule("?") % :nonassoc ^ 7
    rule("|") % :nonassoc ^ 7

    ['.', ':', '[', ']'].each do |symbol|
      rule symbol % :nonassoc
    end

    ['=', '$', '(', ')', '{', '}', '`', '\'', ';', '@', ',', '..', '=>'].each do |symbol|
      rule symbol % :right
    end

    rule :t_object => /#-?[0-9]+/

    rule :t_integer => /[0-9]+/

    rule :t_float => /[0-9]+\.[0-9]+/

    # source: http://stackoverflow.com/questions/249791/regex-for-quoted-string-with-escaping-quotes
    rule :t_string => /"(?:[^"\\]|\\.)*"/

    rule :t_error => /E_(NONE|TYPE|DIV|PERM|PROPNF|VERBNF|VARNF|INVIND|RECMOVE|MAXREC|RANGE|ARGS|NACC|INVARG|QUOTA|FLOAT)/i

    rule :t_id => /[a-z_][a-z0-9_]*/i

    # Source: http://ostermiller.org/findcomment.html
    # rule :comment => /\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+/

    start :program
  end
end
