defmodule ParserTest do
  import Toothpick.Parser, only: [parse: 1, statement: 2]
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

  test "correctly parses if statement with no else clauses" do
    assert(
      statement(
        [],
        keyword: "if",
        new_line: "\n",
        variable: "a",
        punctuator: ":",
        keyword: "return",
        integer: "1",
        new_line: "\n",
        punctuator: ".",
        new_line: "\n"
      ) == [
        if_statement: [
          condition: {:variable, "a"},
          yes: {:return_statement, {:integer, "1"}},
          no: []
        ]
      ]
    )
  end

  test "correctly parses if statement with else clauses" do
    assert(
      statement(
        [],
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
      ) == [
        if_statement: [
          condition: {:variable, "a"},
          yes: {:return_statement, {:integer, "1"}},
          no: [
            if_statement: [
              condition: {:function_call, [calle: "cond", args: [{:variable, "a"}, {:integer, "4"}]]},
              yes: {:return_statement, {:integer, "2"}},
              no: [
                if_statement: [
                  condition: {:boolean, "true"},
                  yes: {:return_statement, {:integer, "3"}},
                  no: []
                ]
              ]
            ]
          ]
        ]
      ]
    )
  end
end
