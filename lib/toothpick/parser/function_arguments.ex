defmodule Toothpick.Parser.FunctionArguments do
  # Arguments of a function is a list of variables. It ends with {:punctuator, '->'}.
  def function_arguments(tree, tokens) do
    {children, tail} =
      if arguments_are_horizontal(tokens) do
        horizontal_args([], tokens)
      else
        vertical_args([], tokens)
      end

    {tree ++ [{:function_arguments, children}], tail}
  end

  # Decides if arguments have newlines.
  defp arguments_are_horizontal([{:new_line, _} | _]), do: false
  defp arguments_are_horizontal(_), do: true

  # Process arguments without newlines.
  defp horizontal_args(args, [{:variable, name} | tail]), do: horizontal_args(args ++ [{:variable, name}], tail)

  defp horizontal_args(_, [{:new_line, _} | _]),
    do: raise("inconsistent arguments syntax, arguments should be multi-line")

  defp horizontal_args(args, tail), do: {args, tail}

  # Process arguments with newlines.
  defp vertical_args(args, [{:new_line, _}, {:variable, name} | tail]),
    do: vertical_args(args ++ [{:variable, name}], tail)

  defp vertical_args([args_head | args_tail], [{:new_line, _}, {:punctuator, "->"} | tail]),
    do: {[args_head | args_tail], [{:punctuator, "->"} | tail]}

  defp vertical_args(_, _), do: raise("inconsistent arguments syntax, arguments should be single-line")
end
