defmodule Toothpick.Parser.Expression do
  def expression([{:variable, value}, {:punctuator, "("} | tail]) do
    function_call({:variable, value}, [{:punctuator, "("} | tail])
  end

  def expression([{:identifier, value}, {:punctuator, "("} | tail]) do
    function_call({:identifier, value}, [{:punctuator, "("} | tail])
  end

  def expression([{:string, value} | tail]), do: {{:string, value}, tail}
  def expression([{:variable, value} | tail]), do: {{:variable, value}, tail}
  def expression([{:integer, value} | tail]), do: {{:integer, value}, tail}
  def expression([{:boolean, value} | tail]), do: {{:boolean, value}, tail}
  def expression(tail), do: {nil, tail}

  def function_call(tree, [{:punctuator, "("} | tail]) do
    {args, tail} = call_arguments([], tail)
    function = {:function_call, [calle: tree, args: args]}
    function_call(function, tail)
  end

  def function_call(tree, tail), do: {tree, tail}

  defp call_arguments(args, [{:punctuator, ")"} | tail]), do: {args, tail}
  defp call_arguments(args, [{:punctuator, ","} | tail]), do: call_arguments(args, tail)

  defp call_arguments(args, tokens) do
    {argument, tail} = expression(tokens)
    call_arguments(args ++ [argument], tail)
  end
end
