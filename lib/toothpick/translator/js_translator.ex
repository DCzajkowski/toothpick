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

  def program_body(tree, [{:function_declaration, function_declaration} | tail]),
    do: program_body(tree ++ [function_declaration(function_declaration)], tail)

  def program_body(tree, tail), do: tree ++ tail

  def function_declaration(identifier: name, function_arguments: function_arguments, function_body: body) do
    %{
      "type" => "FunctionDeclaration",
      "id" => %{"name" => name, "type" => "Identifier"},
      "params" => function_arguments([], function_arguments),
      "body" => %{
        "type" => "BlockStatement",
        "body" => function_body([], body)
      }
    }
  end

  def function_arguments(tree, [{:variable, variable} | tail]),
    do: function_arguments(tree ++ [expression({:variable, variable})], tail)

  def function_arguments(tree, []), do: tree

  def function_body(tree, [{:return_statement, return_statement} | tail]) do
    children = [
      %{
        "type" => "ReturnStatement",
        "argument" => expression(return_statement)
      }
    ]

    function_body(tree ++ children, tail)
  end

  # avcd
  def function_body(tree, tail), do: tree ++ tail

  def expression({:string, string}), do: %{"type" => "Literal", "value" => string}

  def expression({:integer, integer}) do
    {integer, ""} = Integer.parse(integer)
    %{"type" => "Literal", "value" => integer}
  end

  def expression({:boolean, boolean}),
    do: %{"type" => "Literal", "value" => if(boolean == "true", do: true, else: false)}

  def expression({:variable, variable}), do: %{"type" => "Identifier", "name" => variable}

  def expression({:function_call, function_call}) do
    {:identifier, name} = function_call[:calle]

    %{
      "type" => "CallExpression",
      "callee" => %{
        "type" => "Identifier",
        "name" => name
      },
      "arguments" => arguments([], function_call[:args])
    }
  end

  def arguments(tree, [argument | tail]), do: arguments(tree ++ [expression(argument)], tail)
  def arguments(tree, []), do: tree
end
