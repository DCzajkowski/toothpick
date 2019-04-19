defmodule Toothpick.Parser do
  import Toothpick.Parser.FunctionArguments, only: [function_arguments: 2]
  import Toothpick.Parser.Expression, only: [expression: 1]

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

  defp function(tree, tail), do: {tree, tail}

  # Function's body always starts with a {:punctuator, '->'} and is terminated by a {:punctuator, '.'}.
  defp body(tree, [{:punctuator, "->"} | tail]) do
    {children, tail} = statement([], tail)

    {tree ++ [{:function_body, children}], tail}
  end

  defp body(tree, [{:punctuator, "."}, {:new_line, _} | tail]), do: {tree ++ [{:function_body, []}], tail}

  defp statement(tree, [{:keyword, "return"} | tail]) do
    {child, tail} = expression(tail)

    statement(tree ++ [{:return_statement, child}], tail)
  end

  defp statement(tree, [{:keyword, "if"} | tail]) do
    {children, tail} = logical_expression([], tail)
    {children, tail} = body(children, tail)

    statement(tree ++ [{:if_statement, children}], tail)
  end

  defp statement(tree, [{:identifier, value} | tail]) do
    {child, tail} = expression([{:identifier, value} | tail])
    statement(tree ++ [{:expression_statement, child}], tail)
  end

  defp statement(tree, [{:new_line, _} | tail]), do: statement(tree, tail)
  defp statement(tree, [{:punctuator, "."}, {:new_line, _} | tail]), do: {tree, tail}

  defp logical_expression(tree, [{:variable, variable} | tail]),
    do: {tree ++ [{:logical_expression, [{:variable, variable}]}], tail}
end
