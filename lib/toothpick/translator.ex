defmodule Toothpick.Translator do
  def translate(tree) do
    %{
      "type" => "Program",
      "body" => program_body([], tree)
    }
  end

  def program_body(tree, [{:function_declaration, function_declaration} | tail]) do
    name = function_declaration[:identifier]
    body = function_declaration[:function_body]

    children = [
      %{
        "type" => "FunctionDeclaration",
        "id" => %{"name" => name, "type" => "Identifier"},
        "params" => [],
        "body" => %{
          "type" => "BlockStatement",
          "body" => function_body([], body)
        }
      }
    ]

    program_body(tree ++ children, tail)
  end

  def program_body(tree, tail), do: tree ++ tail

  def function_body(tree, [{:return_statement, return_statement} | tail]) do
    children = [
      %{
        "type" => "ReturnStatement",
        "argument" => expression(return_statement)
      }
    ]

    function_body(tree ++ children, tail)
  end

  def function_body(tree, tail), do: tree ++ tail

  def expression({:string, string}), do: %{"type" => "Literal", "value" => string}
end
