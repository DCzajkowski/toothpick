defmodule Mix.Tasks.Tokenize do
  @moduledoc """
  Tokenizes the Toothpick source code.

  This task receives a Toothpick source code as input and
  outputs the tokens list:

      mix tokenize tokenize/some/particular/file.tp

  It is also possible to pass the file contents in stdin:

      cat tokenize/some/particular/file.tp | mix tokenize

  ## Example

  ### Input

      echo "fun main ->
        return 'Hello, World!'
      ." | mix tokenize

  ### Output

      [
        keyword: "fun",
        identifier: "main",
        punctuator: "->",
        new_line: "\\n",
        keyword: "return",
        string: "Hello, World!",
        new_line: "\\n",
        punctuator: ".",
        new_line: "\\n"
      ]
  """

  @shortdoc "Tokenize Toothpick source code"

  use Mix.Task

  def run(argv) do
    argv
    |> Tasks.Helpers.ContentReader.get_content()
    |> Toothpick.Tokenizer.tokens()
    |> IO.inspect(pretty: true)
  end
end
