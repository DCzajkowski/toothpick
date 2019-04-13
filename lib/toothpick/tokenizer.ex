defmodule Toothpick.Tokenizer do
  require Toothpick.Macros
  use Toothpick.Constants

  def tokens(""), do: []
  def tokens(" " <> tail), do: tokens(tail)

  Toothpick.Macros.tokenize(:new_line, :new_line_chars)
  Toothpick.Macros.tokenize(:punctuator, :punctuators)

  def tokens(any) do
    cond do
      (r = try_matching_variable(any)) != :not_matched -> r
      (r = try_matching_identifier(any)) != :not_matched -> r
      (r = try_matching_string(any)) != :not_matched -> r
      true -> raise(ArgumentError, "Could not tokenize #{any}")
    end
  end

  defp try_matching_variable(any) do
    punctuators = Enum.join get(:punctuators)

    case Regex.run(~r/\A@([^\s#{punctuators}]+)(.*)\Z/s, any) do
      [_, variable, tail] -> [{:variable, variable}] ++ tokens(tail)
      _ -> :not_matched
    end
  end

  defp try_matching_identifier(any) do
    case Regex.run(~r/\A([a-zA-Z]+)(.*)\Z/s, any) do
      [_, identifier_or_keyword, tail] -> [identifier_or_keyword(identifier_or_keyword)] ++ tokens(tail)
      _ -> :not_matched
    end
  end

  defp try_matching_string(any) do
    case Regex.run(~r/\A'([^']*)'(.*)\Z/s, any) do
      [_, string, tail] -> [{:string, string}] ++ tokens(tail)
      _ -> :not_matched
    end
  end

  defp identifier_or_keyword("fun"), do: {:keyword, "fun"}
  defp identifier_or_keyword("return"), do: {:keyword, "return"}
  defp identifier_or_keyword(any), do: {:identifier, any}
end
