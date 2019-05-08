defmodule Toothpick.Parser do
  import Toothpick.Parser.FunctionArguments, only: [function_arguments: 2]
  import Toothpick.Parser.Expression, only: [expression: 1, function_call: 2]

  def parse(tokens), do: program(tokens)

  # Parses the very top level of a program. A program can consist only of function declarations.
  defp program(tokens), do: elem(function([], tokens), 0)

  # Parses the function definition. A function always starts with a keyword 'fun' and identifier.
  # It is then followed by an optional list of arguments and body.
  defp function(tree, [{:keyword, "fun"}, {:identifier, name} | tail]) do
    children = [{:identifier, name}]

    {children, tail} = function_arguments(children, tail)
    {children, tail} = body(children, tail)

    function(tree ++ [{:function_declaration, children}], tail)
  end

  defp function(tree, [{:new_line, _} | tail]), do: function(tree, tail)
  defp function(tree, tail), do: {tree, tail}

  # Function's body always starts with a {:punctuator, '->'} and is terminated by a {:punctuator, '.'}.
  defp body(tree, [{:punctuator, "->"} | tail]) do
    {children, tail} = statement([], tail)

    {tree ++ [{:function_body, children}], tail}
  end

  defp body(tree, [{:punctuator, "."}, {:new_line, _} | tail]),
    do: {tree ++ [{:function_body, []}], tail}


  def statement(tree, [{:keyword, "if"}, {:new_line, _}  | tail]) do
    {conditions, tail} = parse_cases(tail)
    statement(
      tree ++ conditions,
      tail
    )
  end

  def statement(tree, [{:keyword, "if"} | tail]) do
    {condition, tail} = expression(tail)
    {yes, tail} = case tail do
      [{:punctuator, ":"}, {:new_line, _} | inner_tail] -> statement([], inner_tail)
      [{:punctuator, ":"} | inner_tail] -> line_statement(inner_tail)
    end
    statement(
      tree ++ [{:if_statement, [{:condition, condition}, {:yes, yes}, {:no, []}]}],
      tail
    )
  end

  def statement(tree, [{:new_line, _} | tail]), do: statement(tree, tail)
  def statement(tree, [{:punctuator, "."}, {:new_line, _} | tail]), do: {tree, tail}
  def statement(tree, []), do: {tree,[]}
  def statement(tree, tail) do
    {statement, tail} = line_statement(tail)
    statement(tree ++ statement, tail)
  end

  defp parse_cases([{:new_line, _} | tail]), do: parse_cases(tail)
  defp parse_cases([{:punctuator, "."}, {:new_line, _} | tail]), do: {[],tail}
  defp parse_cases(tail) do
    {condition, tail} = expression(tail)
    [{:punctuator, ":"} | tail] = tail
    {yes, tail} = line_statement(tail)
    {no, tail} = parse_cases(tail)
    {[{:if_statement, [{:condition, condition}, {:yes, yes}, {:no, no}]}], tail}
  end

  def line_statement([{:keyword, "return"} | tail]) do
    {child, tail} = expression(tail)
    {[{:return_statement, child}], tail}
  end

  def line_statement([{:variable, value}, {:punctuator, "("} | tail]) do
    {call, tail} = function_call({:variable, value}, [{:punctuator, "("} | tail])
    {[{:call_statement, call}], tail}
  end

  def line_statement([{:identifier, value}, {:punctuator, "("} | tail]) do
    {call, tail} = function_call({:identifier, value}, [{:punctuator, "("} | tail])
    {[{:call_statement, call}], tail}
  end
end
