defmodule Mix.Tasks.Tokenize do
  use Mix.Task

  @shortdoc "Tokenize toothpick source code"

  def run(argv) do
    List.first(argv)
    |> File.read!()
    |> Toothpick.Tokenizer.tokens()
    |> IO.inspect(pretty: true)
  end
end
