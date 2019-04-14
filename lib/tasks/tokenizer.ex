defmodule Mix.Tasks.Tokenize do
  use Mix.Task

  @shortdoc "Tokenize toothpick source code"

  def run(argv) do
    filename = List.first(argv)

    {:ok, content} = File.read(filename)

    IO.puts(Toothpick.Tokenizer.tokens(content))
  end
end
