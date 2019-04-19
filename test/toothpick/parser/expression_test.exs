defmodule FunctionExpressionTest do
  import Toothpick.Parser.Expression, only: [expression: 1]
  use ExUnit.Case

  doctest Toothpick.Parser.Expression

  test "correctly parses function call with variable as callee" do
    tokens = [
      variable: "a",
      punctuator: "(",
      punctuator: ")"
    ]

    {tree, _} = expression(tokens)

    assert(
      tree ==
        {
          :function_call,
          [
            calle: {:variable, "a"},
            args: []
          ]
        }
    )
  end

  test "correctly parses function call with identifier as callee" do
    tokens = [
      identifier: "main",
      punctuator: "(",
      punctuator: ")"
    ]

    {tree, _} = expression(tokens)

    assert(
      tree ==
        {
          :function_call,
          [
            calle: {:identifier, "main"},
            args: []
          ]
        }
    )
  end

  test "correctly parses function call with function call as callee" do
    tokens = [
      variable: "a",
      punctuator: "(",
      punctuator: ")",
      punctuator: "(",
      punctuator: ")"
    ]

    {tree, _} = expression(tokens)

    assert(
      tree ==
        {
          :function_call,
          [
            calle: {
              :function_call,
              [
                calle: {:variable, "a"},
                args: []
              ]
            },
            args: []
          ]
        }
    )
  end

  test "correctly parses function call with integer as argument" do
    tokens = [
      variable: "a",
      punctuator: "(",
      integer: 1,
      punctuator: ")"
    ]

    {tree, _} = expression(tokens)

    assert(
      tree ==
        {
          :function_call,
          [
            calle: {:variable, "a"},
            args: [integer: 1]
          ]
        }
    )
  end

  test "correctly parses function call with string as argument" do
    tokens = [
      variable: "a",
      punctuator: "(",
      string: "text",
      punctuator: ")"
    ]

    {tree, _} = expression(tokens)

    assert(
      tree ==
        {
          :function_call,
          [
            calle: {:variable, "a"},
            args: [string: "text"]
          ]
        }
    )
  end

  test "correctly parses function call with variable as argument" do
    tokens = [
      variable: "a",
      punctuator: "(",
      variable: "a",
      punctuator: ")"
    ]

    {tree, _} = expression(tokens)

    assert(
      tree ==
        {
          :function_call,
          [
            calle: {:variable, "a"},
            args: [variable: "a"]
          ]
        }
    )
  end

  test "correctly parses function call with function call as argument" do
    tokens = [
      variable: "a",
      punctuator: "(",
      variable: "b",
      punctuator: "(",
      punctuator: ")",
      punctuator: ")"
    ]

    {tree, _} = expression(tokens)

    assert(
      tree ==
        {
          :function_call,
          [
            calle: {:variable, "a"},
            args: [
              function_call: [
                calle: {:variable, "b"},
                args: []
              ]
            ]
          ]
        }
    )
  end
end
