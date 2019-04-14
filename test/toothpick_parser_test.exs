defmodule ToothpickParserTest do
  import Toothpick.Parser, only: [parse: 1]
  use ExUnit.Case

  doctest Toothpick.Parser

  test "correctly parses function without arguments" do
    assert parse(
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
  end

  test "correctly parses function with arguments" do
    assert parse(
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
  end
end
