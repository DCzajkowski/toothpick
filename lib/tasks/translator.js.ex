defmodule Mix.Tasks.Translate.Js do
  @moduledoc """
  Translates Toothpick AST to JS AST.

  This task receives a Toothpick AST as input and
  outputs the JS AST in JSON:

      mix translate.js file/containing/toothpick/ast.txt

  It is also possible to pass the file contents in stdin:

      cat file/containing/toothpick/ast.txt | mix translate.js

  ## Example

  ### Input

      echo '[
        function_declaration: [
          identifier: "main",
          function_arguments: [],
          function_body: [return_statement: {:string, "Hello, World!"}]
        ]
      ]' | mix translate.js

  ### Output

      {"type":"Program","body":[{"type":"FunctionDeclaration","params":[],"id":{"type":"Identifier","name":"main"},"body":{"type":"BlockStatement","body":[{"type":"ReturnStatement","argument":{"value":"Hello, World!","type":"Literal"}}]}},{"type":"ExpressionStatement","expression":{"type":"CallExpression","callee":{"type":"Identifier","name":"main"},"arguments":[]}}]}
  """

  @shortdoc "Translate Toothpick AST to JS AST"

  use Mix.Task

  def run(argv) do
    argv
    |> Tasks.Helpers.ContentReader.get_content()
    |> Tasks.Helpers.ElixirParser.parse()
    |> Toothpick.Translator.JsTranslator.translate()
    |> IO.inspect(pretty: true, limit: :infinity)
  end
end
