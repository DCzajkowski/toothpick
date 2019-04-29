defmodule Toothpick.Translator.JsTranslator do
  def translate(tree) do
    %{
      "type" => "Program",
      "body" => program_body([], tree)
    }
  end

  def preamble() do
    "/* [standard library is normally included here] */\n"
  end

  def ending() do
    """
    const statusOrPrintable = main();
    if (statusOrPrintable === 0 || statusOrPrintable === 1) {
      process.exit(statusOrPrintable);
    } else {
      console.log(statusOrPrintable);
    }
    """
  end

  defp program_body(tree, [{:function_declaration, function_declaration} | tail]) do
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

  defp program_body(tree, tail), do: tree ++ tail

  defp function_body(tree, [{:return_statement, return_statement} | tail]) do
    children = [
      %{
        "type" => "ReturnStatement",
        "argument" => expression(return_statement)
      }
    ]

    function_body(tree ++ children, tail)
  end

  defp function_body(tree, tail), do: tree ++ tail

  defp expression({:string, string}), do: %{"type" => "Literal", "value" => string}
end
