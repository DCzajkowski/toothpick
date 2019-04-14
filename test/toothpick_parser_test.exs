defmodule ToothpickParserTest do
  import Toothpick.Parser, only: [parse: 1]
  use ExUnit.Case

  doctest Toothpick.Parser

  test "correctly parses function without arguments" do
    assert parse([
      {:keyword, "fun"},
      {:identifier, "main"},
      {:new_line, "\n"},
      {:keyword, "return"},
      {:string, "Hello, World!"},
      {:new_line, "\n"},
      {:punctuator, "."},
      {:new_line, "\n"},
    ]) == %{
      type: "Program",
      body: [
        %{
          type: "FunctionDeclaration",
          id: %{
            type: "Identifier",
            name: "main"
          },
          params: [],
          body: %{
            type: "BlockStatement",
            body: [
              %{
                type: "ReturnStatement",
                argument: %{
                  type: "Literal",
                  value: "Hello, World!",
                  raw: "'Hello, World!'"
                }
              }
            ]
          },
          generator: false,
          expression: false,
          async: false
        }
      ],
    }
  end
end
