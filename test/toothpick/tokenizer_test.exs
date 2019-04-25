defmodule TokenizerTest do
  import Toothpick.Tokenizer, only: [tokens: 1]
  use ExUnit.Case

  doctest Toothpick.Tokenizer

  defp stub(filename) do
    File.cwd!()
    |> Path.join("/test/stubs/#{filename}.tp")
    |> File.read!()
  end

  test "correctly tokenizes booleans" do
    assert(
      tokens("true false") == [
        boolean: "true",
        boolean: "false"
      ]
    )
  end

  test "correctly tokenizes function without arguments" do
    assert(
      tokens(stub("function_without_arguments")) == [
        keyword: "fun",
        identifier: "main",
        punctuator: "->",
        new_line: "\n",
        keyword: "return",
        string: "Hello, World!",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n"
      ]
    )
  end

  test "correctly tokenizes function with arguments" do
    assert(
      tokens(stub("function_with_arguments")) == [
        keyword: "fun",
        identifier: "add",
        variable: "a",
        variable: "b",
        new_line: "\n",
        keyword: "return",
        identifier: "Math",
        punctuator: ".",
        identifier: "add",
        punctuator: "(",
        variable: "a",
        punctuator: ",",
        variable: "b",
        punctuator: ")",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n"
      ]
    )
  end

  test "correctly tokenizes function with multiline arguments" do
    assert(
      tokens(stub("function_with_multiline_arguments")) == [
        keyword: "fun",
        identifier: "func",
        new_line: "\n",
        variable: "first",
        new_line: "\n",
        variable: "second",
        new_line: "\n",
        variable: "third",
        new_line: "\n",
        punctuator: "->",
        new_line: "\n",
        keyword: "if",
        identifier: "eq",
        punctuator: "(",
        variable: "second",
        punctuator: ",",
        integer: "1",
        punctuator: ")",
        new_line: "\n",
        keyword: "return",
        integer: "2",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n",
        keyword: "return",
        identifier: "add",
        punctuator: "(",
        variable: "first",
        punctuator: ",",
        variable: "third",
        punctuator: ")",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n"
      ]
    )
  end

  test "correctly tokenizes multiple advanced functions" do
    assert(
      tokens(stub("multiple_advanced_functions")) == [
        keyword: "fun",
        identifier: "fib",
        variable: "n",
        new_line: "\n",
        keyword: "if",
        identifier: "Math",
        punctuator: ".",
        identifier: "le",
        punctuator: "(",
        variable: "n",
        punctuator: ",",
        integer: "1",
        punctuator: ")",
        new_line: "\n",
        keyword: "return",
        integer: "1",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n",
        keyword: "return",
        identifier: "Math",
        punctuator: ".",
        identifier: "add",
        punctuator: "(",
        identifier: "fib",
        punctuator: "(",
        identifier: "Math",
        punctuator: ".",
        identifier: "sub",
        punctuator: "(",
        variable: "n",
        punctuator: ",",
        integer: "1",
        punctuator: ")",
        punctuator: ")",
        punctuator: ",",
        identifier: "fib",
        punctuator: "(",
        identifier: "Math",
        punctuator: ".",
        identifier: "sub",
        punctuator: "(",
        variable: "n",
        punctuator: ",",
        integer: "2",
        punctuator: ")",
        punctuator: ")",
        punctuator: ")",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n",
        keyword: "fun",
        identifier: "main",
        new_line: "\n",
        punctuator: "[",
        integer: "1",
        punctuator: ",",
        integer: "2",
        punctuator: ",",
        integer: "3",
        punctuator: ",",
        integer: "4",
        punctuator: "]",
        new_line: "\n",
        punctuator: ">",
        identifier: "map",
        punctuator: "(",
        punctuator: "$",
        punctuator: ",",
        identifier: "fib",
        punctuator: ")",
        new_line: "\n",
        punctuator: ">",
        identifier: "map",
        punctuator: "(",
        punctuator: "$",
        punctuator: ",",
        variable: "i",
        punctuator: "->",
        identifier: "String",
        punctuator: ".",
        identifier: "concat",
        punctuator: "(",
        variable: "i",
        punctuator: ",",
        string: "\\n",
        punctuator: ")",
        punctuator: ")",
        new_line: "\n",
        punctuator: ">",
        identifier: "each",
        punctuator: "(",
        punctuator: "$",
        punctuator: ",",
        identifier: "IO",
        punctuator: ".",
        identifier: "print",
        punctuator: ")",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n"
      ]
    )
  end
end
