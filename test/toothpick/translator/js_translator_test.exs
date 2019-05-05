defmodule JsTranslatorTest do
  import Toothpick.Translator.JsTranslator,
    only: [translate: 1, function_declaration: 1, function_body: 2]

  use ExUnit.Case

  doctest Toothpick.Translator.JsTranslator

  test "it translates a program with multiple function declarations" do
    assert(
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
      ) == %{
        "type" => "Program",
        "body" => [
          %{
            "type" => "FunctionDeclaration",
            "id" => %{"name" => "a", "type" => "Identifier"},
            "params" => [],
            "body" => %{
              "type" => "BlockStatement",
              "body" => [
                %{
                  "type" => "ReturnStatement",
                  "argument" => %{"type" => "Literal", "value" => "a"}
                }
              ]
            }
          },
          %{
            "type" => "FunctionDeclaration",
            "id" => %{"name" => "main", "type" => "Identifier"},
            "params" => [],
            "body" => %{
              "type" => "BlockStatement",
              "body" => [
                %{
                  "type" => "ReturnStatement",
                  "argument" => %{"type" => "Literal", "value" => "Hello, World!"}
                }
              ]
            }
          }
        ]
      }
    )
  end

  test "it translates an argument-less function returning a string" do
    assert(
      function_declaration(
        identifier: "main",
        function_arguments: [],
        function_body: [
          return_statement: {:string, "Hello, World!"}
        ]
      ) == %{
        "type" => "FunctionDeclaration",
        "id" => %{"name" => "main", "type" => "Identifier"},
        "params" => [],
        "body" => %{
          "type" => "BlockStatement",
          "body" => [
            %{
              "type" => "ReturnStatement",
              "argument" => %{"type" => "Literal", "value" => "Hello, World!"}
            }
          ]
        }
      }
    )
  end

  test "it translates a function body returning a string" do
    assert(
      function_body(
        [],
        return_statement: {:string, "Hello, World!"}
      ) == [
        %{
          "type" => "ReturnStatement",
          "argument" => %{"type" => "Literal", "value" => "Hello, World!"}
        }
      ]
    )
  end

  test "it translates a function body returning an integer" do
    assert(
      function_body(
        [],
        return_statement: {:integer, "2"}
      ) == [
        %{
          "type" => "ReturnStatement",
          "argument" => %{"type" => "Literal", "value" => 2}
        }
      ]
    )
  end

  test "it translates a function body returning a boolean" do
    assert(
      function_body(
        [],
        return_statement: {:boolean, "true"}
      ) == [
        %{
          "type" => "ReturnStatement",
          "argument" => %{"type" => "Literal", "value" => true}
        }
      ]
    )
  end

  test "it translates a function body returning a variable" do
    assert(
      function_body(
        [],
        return_statement: {:variable, "a"}
      ) == [
        %{
          "type" => "ReturnStatement",
          "argument" => %{"type" => "Identifier", "name" => "a"}
        }
      ]
    )
  end

  test "it translates a function body returning a function call" do
    assert(
      function_body(
        [],
        return_statement:
          {:function_call,
           [
             calle: {:identifier, "b"},
             args: [
               integer: "5",
               string: "hello",
               boolean: "true",
               variable: "variable",
               function_call: [calle: {:identifier, "c"}, args: [string: "world"]]
             ]
           ]}
      ) == [
        %{
          "type" => "ReturnStatement",
          "argument" => %{
            "type" => "CallExpression",
            "callee" => %{
              "type" => "Identifier",
              "name" => "b"
            },
            "arguments" => [
              %{"type" => "Literal", "value" => 5},
              %{"type" => "Literal", "value" => "hello"},
              %{"type" => "Literal", "value" => true},
              %{"type" => "Identifier", "name" => "variable"},
              %{
                "type" => "CallExpression",
                "callee" => %{
                  "type" => "Identifier",
                  "name" => "c"
                },
                "arguments" => [
                  %{
                    "type" => "Literal",
                    "value" => "world"
                  }
                ]
              }
            ]
          }
        }
      ]
    )
  end

  test "it translates an if statement without else clauses" do
    assert(
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
      ) == [
        %{
          "type" => "IfStatement",
          "test" => %{
            "type" => "CallExpression",
            "callee" => %{"type" => "Identifier", "name" => "lte"},
            "arguments" => [
              %{"type" => "Identifier", "name" => "n"},
              %{"type" => "Literal", "value" => 1}
            ]
          },
          "consequent" => %{
            "type" => "BlockStatement",
            "body" => [
              %{
                "type" => "ReturnStatement",
                "argument" => %{"type" => "Literal", "value" => 1}
              }
            ]
          },
          "alternate" => nil
        }
      ]
    )
  end

  test "it translates an if statement with complicated else clauses" do
    assert(
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
      ) == [
        %{
          "type" => "IfStatement",
          "test" => %{
            "type" => "CallExpression",
            "callee" => %{"type" => "Identifier", "name" => "lte"},
            "arguments" => [
              %{"type" => "Identifier", "name" => "num"},
              %{"type" => "Literal", "value" => 1}
            ]
          },
          "consequent" => %{
            "type" => "BlockStatement",
            "body" => [
              %{
                "type" => "ReturnStatement",
                "argument" => %{
                  "type" => "CallExpression",
                  "callee" => %{"type" => "Identifier", "name" => "format"},
                  "arguments" => [
                    %{"type" => "Literal", "value" => "$ is not a prime number"},
                    %{"type" => "Identifier", "name" => "num"}
                  ]
                }
              }
            ]
          },
          "alternate" => %{
            "type" => "BlockStatement",
            "body" => [
              %{
                "type" => "IfStatement",
                "test" => %{
                  "type" => "CallExpression",
                  "callee" => %{"type" => "Identifier", "name" => "contains"},
                  "arguments" => [
                    %{
                      "type" => "CallExpression",
                      "callee" => %{"type" => "Identifier", "name" => "range"},
                      "arguments" => [
                        %{"type" => "Literal", "value" => 2},
                        %{"type" => "Identifier", "name" => "num"}
                      ]
                    },
                    %{"type" => "Literal", "value" => true}
                  ]
                },
                "consequent" => %{
                  "type" => "BlockStatement",
                  "body" => [
                    %{
                      "type" => "ReturnStatement",
                      "argument" => %{
                        "type" => "CallExpression",
                        "callee" => %{"type" => "Identifier", "name" => "format"},
                        "arguments" => [
                          %{"type" => "Literal", "value" => "$ is not a prime number"},
                          %{"type" => "Identifier", "name" => "num"}
                        ]
                      }
                    }
                  ]
                },
                "alternate" => %{
                  "type" => "BlockStatement",
                  "body" => [
                    %{
                      "type" => "IfStatement",
                      "test" => %{"type" => "Literal", "value" => true},
                      "consequent" => %{
                        "type" => "BlockStatement",
                        "body" => [
                          %{
                            "type" => "ReturnStatement",
                            "argument" => %{
                              "type" => "CallExpression",
                              "callee" => %{"type" => "Identifier", "name" => "format"},
                              "arguments" => [
                                %{
                                  "type" => "Literal",
                                  "value" => "$ is a prime number"
                                },
                                %{"type" => "Identifier", "name" => "num"}
                              ]
                            }
                          }
                        ]
                      },
                      "alternate" => nil
                    }
                  ]
                }
              }
            ]
          }
        }
      ]
    )
  end
end
