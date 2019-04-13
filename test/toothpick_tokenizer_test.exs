defmodule ToothpickTokenizerTest do
  use ExUnit.Case
  doctest Toothpick.Tokenizer

  test "correctly tokenizes function without arguments returning void" do
    {:ok, code} = File.cwd!()
      |> Path.join("/test/stubs/function_without_arguments_returning_void.tp")
      |> File.read()

    assert Toothpick.Tokenizer.tokens(code) == [
      {:keyword, "fun"},
      {:identifier, "main"},
      {:punctuator, "->"},
      {:identifier, "Void"},
      {:punctuator, "."},
      {:new_line, "\n"},
    ]
  end
end
