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

  defp body(tree, [{:punctuator, "."}, {:new_line, _} | tail]), do: {tree ++ [{:function_body, []}], tail}

  def statement(tree, [{:keyword, "return"} | tail]) do
    {child, tail} = expression(tail)

    statement(tree ++ [{:return_statement, child}], tail)
  end

  def statement(_tree, [{:keyword, "if"}, {:new_line, _}, {:punctuator, "."} | _tail]), do: []

  def statement(tree, [{:keyword, "if"}, {:new_line, _} | tail]) do
    {condition, tail} = condition(tail)

    {yes, tail} = single_statement(tail)

    no = statement([], [{:keyword, "if"}] ++ tail)

    {tree, _} =
      statement(
        tree ++ [{:if_statement, [condition, {:yes, yes}, {:no, no}]}],
        tail
      )

    tree
  end

  def statement(tree, [{:new_line, _} | tail]), do: statement(tree, tail)
  def statement(tree, [{:punctuator, "."}, {:new_line, _} | tail]), do: {tree, tail}
  def statement(tree, tail), do: {tree, tail}

  defp condition([{:variable, variable}, {:punctuator, ":"} | tail]),
    do: {{:condition, {:variable, variable}}, tail}

  defp condition([{:identifier, identifier}, {:punctuator, "("} | tail]) do
    {condition, tail} = function_call(identifier, [{:punctuator, "("}] ++ tail)

    [{:punctuator, ":"} | tail] = tail

    {{:condition, condition}, tail}
  end

  defp condition([{:boolean, boolean}, {:punctuator, ":"} | tail]),
    do: {{:condition, {:boolean, boolean}}, tail}

  def single_statement([{:keyword, "return"} | tail]) do
    {child, tail} = expression(tail)

    {{:return_statement, child}, tail}
  end
end
