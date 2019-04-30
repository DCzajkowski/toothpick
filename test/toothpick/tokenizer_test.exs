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
        punctuator: "->",
        new_line: "\n",
        keyword: "return",
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
        new_line: "\n",
        identifier: "eq",
        punctuator: "(",
        variable: "second",
        punctuator: ",",
        integer: "1",
        punctuator: ")",
        punctuator: ":",
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
      tokens(stub("fibonacci")) == [
        new_line: "\n",
        keyword: "fun",
        identifier: "fib",
        variable: "n",
        punctuator: "->",
        new_line: "\n",
        keyword: "if",
        new_line: "\n",
        identifier: "lte",
        punctuator: "(",
        variable: "n",
        punctuator: ",",
        integer: "2",
        punctuator: ")",
        punctuator: ":",
        keyword: "return",
        integer: "1",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n",
        keyword: "return",
        identifier: "add",
        punctuator: "(",
        identifier: "fib",
        punctuator: "(",
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
        punctuator: "->",
        new_line: "\n",
        keyword: "return",
        identifier: "format",
        punctuator: "(",
        string: "The $th fibonacci number is $!",
        punctuator: ",",
        integer: "4",
        punctuator: ",",
        identifier: "fib",
        punctuator: "(",
        integer: "4",
        punctuator: ")",
        punctuator: ")",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n"
      ]
    )
  end

  test "correctly tokenizes if statement with no else clauses" do
    assert(
      tokens("""
      if @a :
        return 1
      .
      """) == [
        keyword: "if",
        variable: "a",
        punctuator: ":",
        new_line: "\n",
        keyword: "return",
        integer: "1",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n"
      ]
    )
  end

  test "correctly tokenizes if statement with else clauses" do
    assert(
      tokens("""
      if
        @a : return 1
        cond(@a, 4) : return 2
        true : return 3
      .
      """) == [
        keyword: "if",
        new_line: "\n",
        variable: "a",
        punctuator: ":",
        keyword: "return",
        integer: "1",
        new_line: "\n",
        identifier: "cond",
        punctuator: "(",
        variable: "a",
        punctuator: ",",
        integer: "4",
        punctuator: ")",
        punctuator: ":",
        keyword: "return",
        integer: "2",
        new_line: "\n",
        boolean: "true",
        punctuator: ":",
        keyword: "return",
        integer: "3",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n"
      ]
    )
  end
end
