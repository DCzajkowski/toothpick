defmodule ParserTest do
  import Toothpick.Parser, only: [parse: 1]
  use ExUnit.Case

  doctest Toothpick.Parser

  test "correctly parses function without arguments" do
    assert(
      parse(
        keyword: "fun",
        identifier: "main",
        punctuator: "->",
        new_line: "\n",
        keyword: "return",
        string: "Hello, World!",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n"
      ) == [
        function_declaration: [
          identifier: "main",
          function_arguments: [],
          function_body: [
            return_statement: {:string, "Hello, World!"}
          ]
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
        punctuator: "->",
        new_line: "\n",
        keyword: "return",
        variable: "a",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n"
      ) == [
        function_declaration: [
          identifier: "add",
          function_arguments: [variable: "a", variable: "b"],
          function_body: [
            return_statement: {:variable, "a"}
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
        punctuator: "->",
        new_line: "\n",
        keyword: "if",
        variable: "n",
        punctuator: "->",
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
          identifier: "abcd",
          function_arguments: [variable: "n"],
          function_body: [
            if_statement: [
              logical_expression: [variable: "n"],
              function_body: [
                return_statement: {:integer, "1"}
              ]
            ],
            return_statement: {:integer, "2"}
          ]
        ]
      ]
    )
  end

  test "correctly parses complicated function call" do
    assert(
      parse(
        keyword: "fun",
        identifier: "add",
        variable: "a",
        variable: "b",
        punctuator: "->",
        new_line: "\n",
        keyword: "return",
        variable: "a",
        punctuator: "(",
        identifier: "stop",
        punctuator: "(",
        punctuator: ")",
        punctuator: ",",
        variable: "b",
        punctuator: ")",
        punctuator: "(",
        punctuator: ")",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n"
      ) == [
        function_declaration: [
          identifier: "add",
          function_arguments: [
            variable: "a",
            variable: "b"
          ],
          function_body: [
            return_statement: {
              :function_call,
              [
                calle: {
                  :function_call,
                  [
                    calle: {:variable, "a"},
                    args: [
                      function_call: [
                        calle: {:identifier, "stop"},
                        args: []
                      ],
                      variable: "b"
                    ]
                  ]
                },
                args: []
              ]
            }
          ]
        ]
      ]
    )
  end
end
