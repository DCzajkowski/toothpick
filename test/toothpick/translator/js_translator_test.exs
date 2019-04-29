defmodule JsTranslatorTest do
  import Toothpick.Translator.JsTranslator, only: [translate: 1]
  use ExUnit.Case

  doctest Toothpick.Translator.JsTranslator

  test "it correctly translates a function with no arguments" do
    assert(
      translate(
        function_declaration: [
          identifier: "main",
          function_arguments: [],
          function_body: [
            return_statement: {:string, "Hello, World!"}
          ]
        ]
      ) == %{
        "body" => [
          %{
            "body" => %{
              "body" => [
                %{
                  "argument" => %{"type" => "Literal", "value" => "Hello, World!"},
                  "type" => "ReturnStatement"
                }
              ],
              "type" => "BlockStatement"
            },
            "id" => %{"name" => "main", "type" => "Identifier"},
            "params" => [],
            "type" => "FunctionDeclaration"
          }
        ],
        "type" => "Program"
      }
    )
  end
end
