defmodule Toothpick.CLI do
  def main(args \\ []) do
    filename = hd(args)

    {:ok, content} = File.read(filename)

    Toothpick.Lexer.tokens(content)
    |> Stream.map(fn token -> "#{token}\n" end)
    |> Enum.join()
    |> IO.puts()
  end
end
