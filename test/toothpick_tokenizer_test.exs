defmodule ToothpickTokenizerTest do
  use ExUnit.Case
  doctest Toothpick.Tokenizer

  defp stub(filename) do
    File.cwd!()
      |> Path.join("/test/stubs/#{filename}.tp")
      |> File.read!()
  end

  test "correctly tokenizes function without arguments" do
    assert Toothpick.Tokenizer.tokens(stub("function_without_arguments")) == [
      {:keyword, "fun"},
      {:identifier, "main"},
      {:new_line, "\n"},
      {:keyword, "return"},
      {:string, "Hello, World!"},
      {:new_line, "\n"},
      {:punctuator, "."},
      {:new_line, "\n"},
    ]
  end

  test "correctly tokenizes function with arguments" do
    assert Toothpick.Tokenizer.tokens(stub("function_with_arguments")) == [
      {:keyword, "fun"},
      {:identifier, "add"},
      {:variable, "a"},
      {:variable, "b"},
      {:new_line, "\n"},
      {:keyword, "return"},
      {:identifier, "Math"},
      {:punctuator, "."},
      {:identifier, "add"},
      {:punctuator, "("},
      {:variable, "a"},
      {:punctuator, ","},
      {:variable, "b"},
      {:punctuator, ")"},
      {:new_line, "\n"},
      {:punctuator, "."},
      {:new_line, "\n"},
    ]
  end

end
