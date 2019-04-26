defmodule Mix.Tasks.Parse do
  @moduledoc """
  Parses Toothpick tokens list to the Toothpick AST.

  This task receives a Toothpick tokens list as input and
  outputs the Toothpick AST:

      mix parse file/containing/toothpick/tokens/list.txt

  It is also possible to pass the file contents in stdin:

      cat file/containing/toothpick/tokens/list.txt | mix parse

  ## Example

  ### Input

      echo '[
        keyword: "fun",
        identifier: "main",
        punctuator: "->",
        new_line: "\\n",
        keyword: "return",
        string: "Hello, World!",
        new_line: "\\n",
        punctuator: ".",
        new_line: "\\n"
      ]' | mix parse

  ### Output

      [
        function_declaration: [
          identifier: "main",
          function_arguments: [],
          function_body: [return_statement: {:string, "Hello, World!"}]
        ]
      ]
  """

  @shortdoc "Parse Toothpick tokens to AST"

  use Mix.Task

  def run(argv) do
    argv
    |> Tasks.Helpers.ContentReader.get_content()
    |> Tasks.Helpers.ElixirParser.parse()
    |> Toothpick.Parser.parse()
    |> IO.inspect(pretty: true)
  end
end
