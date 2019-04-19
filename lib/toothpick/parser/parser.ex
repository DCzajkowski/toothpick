defmodule Toothpick.Parser do
  import Toothpick.Parser.FunctionArguments, only: [function_arguments: 2]

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

  # There are two types of statements. :return_statement and :if_statement. In both cases,
  # they are terminated by a {:punctuator, '.'}.
  defp statement(tree, [{:keyword, "return"} | tail]) do
    {child, tail} = expression([], tail)

    statement(tree ++ [{:return_statement, child}], tail)
  end

  defp statement(tree, [{:keyword, "if"} | tail]) do
    {children, tail} = logical_expression([], tail)
    {children, tail} = body(children, tail)

    statement(tree ++ [{:if_statement, children}], tail)
  end

  defp statement(tree, [{:indentifier, value} | tail]) do
    {child, tail} = expression([], [{:indentifier, value} | tail])
    statement(tree ++ [{:expression_statement, child}], tail)
  end

  defp statement(tree, [{:new_line, _} | tail]), do: statement(tree, tail)
  defp statement(tree, [{:punctuator, "."}, {:new_line, _} | tail]), do: {tree, tail}

  defp logical_expression(tree, [{:variable, variable} | tail]),
    do: {tree ++ [{:logical_expression, [{:variable, variable}]}], tail}

  # An expression is a simplest, smallest chunk of the code. It is normally a :string,
  # :variable or :integer.

  defp expression([], [anything, {:punctuator, "("} | tail]) do
    function_call(anything,[{:punctuator, "("} | tail])
  end
  defp expression([], [{:string, value} | tail]), do: {{:string, value}, tail}
  defp expression([], [{:variable, value} | tail]), do: {{:variable, value}, tail}
  defp expression([], [{:integer, value} | tail]), do: {{:integer, value}, tail}
  defp expression([], tail), do: {nil, tail}

  defp function_call(tree, [{:punctuator, "("} | tail]) do
    {args, tail} = arguments([], tail)
    function = [{:function_call, [{:calle, tree}, {:args, args}]}]
    function_call(function, tail)
  end
  defp function_call(tree, tail), do: {tree, tail}


  defp arguments(args, [{:punctuator, ")"} | tail]), do: {args, tail}
  defp arguments(args, [{:punctuator, ","} | tail]), do: arguments(args, tail)
  defp arguments(args, anything) do
    {argument, tail} = expression([], anything)
    arguments(args++[argument], tail)
  end
end
