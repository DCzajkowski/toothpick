defmodule ToothpickParserTest do
  import Toothpick.Parser, only: [parse: 1]
  use ExUnit.Case

  doctest Toothpick.Parser

  test "correctly parses function without arguments" do
    assert(
      parse(
        keyword: "fun",
        identifier: "main",
        new_line: "\n",
        keyword: "return",
        string: "Hello, World!",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n"
      ) == [
        function_declaration: [
          keyword: "fun",
          identifier: "main",
          function_body: [
            return_statement: [
              keyword: "return",
              expression: [string: "Hello, World!"]
            ]
          ]
        ]
      ]
    )
  end

  test "correctly parses function without arguments and shortened body" do
    assert(
      parse(
        keyword: "fun",
        identifier: "main",
        punctuator: "."
      ) == [
        function_declaration: [
          keyword: "fun",
          identifier: "main",
          function_body: []
        ]
      ]
    )
  end

  test "correctly parses function without arguments and body" do
    assert(
      parse(
        keyword: "fun",
        identifier: "main",
        new_line: "\n",
        punctuator: "."
      ) == [
        function_declaration: [
          keyword: "fun",
          identifier: "main",
          function_body: []
        ]
      ]
    )
  end

  test "correctly parses function with arguments" do
    assert(
      parse(
        keyword: "fun",
        identifier: "add",
        variable: "a",
        variable: "b",
        new_line: "\n",
        keyword: "return",
        variable: "a",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n"
      ) == [
        function_declaration: [
          keyword: "fun",
          identifier: "add",
          function_arguments: [variable: "a", variable: "b"],
          function_body: [
            return_statement: [keyword: "return", expression: [variable: "a"]]
          ]
        ]
      ]
    )
  end

  test "correctly parses function with boolean if statement" do
    assert(
      parse(
        keyword: "fun",
        identifier: "abcd",
        variable: "n",
        new_line: "\n",
        keyword: "if",
        variable: "n",
        new_line: "\n",
        keyword: "return",
        integer: "1",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n",
        keyword: "return",
        integer: "2",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n"
      ) == [
        function_declaration: [
          keyword: "fun",
          identifier: "abcd",
          function_arguments: [variable: "n"],
          function_body: [
            if_statement: [
              keyword: "if",
              logical_expression: [variable: "n"],
              function_body: [
                return_statement: [keyword: "return", expression: [integer: "1"]]
              ]
            ],
            return_statement: [keyword: "return", expression: [integer: "2"]]
          ]
        ]
      ]
    )
  end
end
