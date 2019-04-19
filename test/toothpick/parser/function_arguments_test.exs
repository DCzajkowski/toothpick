defmodule FunctionArgumentsTest do
  import Toothpick.Parser.FunctionArguments, only: [function_arguments: 2]
  use ExUnit.Case

  doctest Toothpick.Parser.FunctionArguments

  # fun main ->.
  test "correctly parses no arguments" do
    tokens = [punctuator: "->"]
    {children, tail} = function_arguments([], tokens)
    assert(children == [function_arguments: []])
    assert(tail == tokens)
  end

  # fun main @a @b ->.
  test "correctly parses single-line arguments" do
    tokens = [
      variable: "a",
      variable: "b",
      punctuator: "->"
    ]

    {children, tail} = function_arguments([], tokens)

    assert(
      children == [
        function_arguments: [
          variable: "a",
          variable: "b"
        ]
      ]
    )

    assert(tail == [punctuator: "->"])
  end

  # fun main
  #   @a
  #   @b
  # ->.
  test "correctly parses multi-line arguments" do
    tokens = [
      new_line: "\n",
      variable: "a",
      new_line: "\n",
      variable: "b",
      new_line: "\n",
      punctuator: "->"
    ]

    {children, tail} = function_arguments([], tokens)

    assert(
      children == [
        function_arguments: [
          variable: "a",
          variable: "b"
        ]
      ]
    )

    assert(tail == [punctuator: "->"])
  end

  # fun main @a
  # ->.
  test "throws error when parsing single-line arguments with newline" do
    tokens = [
      variable: "a",
      new_line: "\n",
      punctuator: "->"
    ]

    assert_raise(
      RuntimeError,
      fn -> function_arguments([], tokens) end
    )
  end

  # fun main
  #   @a @b
  # ->.
  test "throws error when parsing multi-line arguments with multiple variables in a single line" do
    tokens = [
      new_line: "\n",
      variable: "a",
      variable: "b",
      new_line: "\n",
      punctuator: "->"
    ]

    assert_raise(
      RuntimeError,
      fn -> function_arguments([], tokens) end
    )
  end

  # fun main
  # ->.
  test "throws error when parsing empty arguments with newline" do
    tokens = [
      new_line: "\n",
      punctuator: "->"
    ]

    assert_raise(
      RuntimeError,
      fn -> function_arguments([], tokens) end
    )
  end
end
