defmodule Toothpick.Tokenizer do
  require Toothpick.Macros
  use Toothpick.Constants

  def tokens(""), do: []
  def tokens(" " <> tail), do: tokens(tail)

  Toothpick.Macros.tokenize(:new_line)
  Toothpick.Macros.tokenize(:punctuator)

  def tokens(any) do
    variable(any)
  end

  defp variable(any) do
    punctuators = Enum.join get(:punctuator)

    case Regex.run(~r/\A@([^\s#{punctuators}]+)(.*)\Z/s, any) do
      [_, variable, tail] -> [{:variable, variable}] ++ tokens(tail)
      _ -> identifier(any)
    end
  end

  defp identifier(any) do
    case Regex.run(~r/\A([a-zA-Z]+)(.*)\Z/s, any) do
      [_, identifier_or_keyword, tail] -> [identifier_or_keyword(identifier_or_keyword)] ++ tokens(tail)
      _ -> string(any)
    end
  end

  defp string(any) do
    case Regex.run(~r/\A'([^']*)'(.*)\Z/s, any) do
      [_, string, tail] -> [{:string, string}] ++ tokens(tail)
      _ -> raise(ArgumentError, "Could not tokenize #{any}")
    end
  end

  defp identifier_or_keyword("fun"), do: {:keyword, "fun"}
  defp identifier_or_keyword("return"), do: {:keyword, "return"}
  defp identifier_or_keyword(any), do: {:identifier, any}
end
