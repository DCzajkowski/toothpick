defmodule JsTranslatorTest do
  import Toothpick.Translator.JsTranslator,
    only: [translate: 1, function_declaration: 1, function_body: 2]

  use Snapshy
  use ExUnit.Case

  doctest Toothpick.Translator.JsTranslator

  test_snapshot "it translates a program with multiple function declarations" do
    translate(
      function_declaration: [
        identifier: "a",
        function_arguments: [],
        function_body: [
          return_statement: {:string, "a"}
        ]
      ],
      function_declaration: [
        identifier: "main",
        function_arguments: [],
        function_body: [
          return_statement: {:string, "Hello, World!"}
        ]
      ]
    )
  end

  test_snapshot "it translates an argument-less function returning a string" do
    function_declaration(
      identifier: "main",
      function_arguments: [],
      function_body: [
        return_statement: {:string, "Hello, World!"}
      ]
    )
  end

  test_snapshot "it translates a function body returning a string" do
    function_body(
      [],
      return_statement: {:string, "Hello, World!"}
    )
  end

  test_snapshot "it translates a function body returning an integer" do
    function_body(
      [],
      return_statement: {:integer, "2"}
    )
  end

  test_snapshot "it translates a function body returning a boolean" do
    function_body(
      [],
      return_statement: {:boolean, "true"}
    )
  end

  test_snapshot "it translates a function body returning a variable" do
    function_body(
      [],
      return_statement: {:variable, "a"}
    )
  end

  test_snapshot "it translates a function body returning a function call" do
    function_body(
      [],
      return_statement: {
        :function_call,
        [
          calle: {:identifier, "b"},
          args: [
            integer: "5",
            string: "hello",
            boolean: "true",
            variable: "variable",
            function_call: [calle: {:identifier, "c"}, args: [string: "world"]]
          ]
        ]
      }
    )
  end

  test_snapshot "it translates an if statement without else clauses" do
    function_body(
      [],
      if_statement: [
        condition: {
          :function_call,
          [calle: {:identifier, "lte"}, args: [variable: "n", integer: "1"]]
        },
        yes: {:return_statement, {:integer, "1"}},
        no: []
      ]
    )
  end

  test_snapshot "it translates an if statement with complicated else clauses" do
    function_body(
      [],
      if_statement: [
        condition: {
          :function_call,
          [calle: {:identifier, "lte"}, args: [variable: "num", integer: "1"]]
        },
        yes: {
          :return_statement,
          {
            :function_call,
            [
              calle: {:identifier, "format"},
              args: [string: "$ is not a prime number", variable: "num"]
            ]
          }
        },
        no: [
          if_statement: [
            condition: {
              :function_call,
              [
                calle: {:identifier, "contains"},
                args: [
                  function_call: [
                    calle: {:identifier, "range"},
                    args: [integer: "2", variable: "num"]
                  ],
                  boolean: "true"
                ]
              ]
            },
            yes: {
              :return_statement,
              {
                :function_call,
                [
                  calle: {:identifier, "format"},
                  args: [string: "$ is not a prime number", variable: "num"]
                ]
              }
            },
            no: [
              if_statement: [
                condition: {:boolean, "true"},
                yes: {
                  :return_statement,
                  {
                    :function_call,
                    [
                      calle: {:identifier, "format"},
                      args: [string: "$ is a prime number", variable: "num"]
                    ]
                  }
                },
                no: []
              ]
            ]
          ]
        ]
      ]
    )
  end
end
