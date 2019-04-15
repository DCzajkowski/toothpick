defmodule Mix.Tasks.Parse do
  use Mix.Task

  @shortdoc "Tokenize and parse toothpick source code"

  def run(argv) do
    List.first(argv)
    |> File.read!()
    |> Toothpick.Tokenizer.tokens()
    |> Toothpick.Parser.parse()
    |> IO.inspect(pretty: true)
  end
end
