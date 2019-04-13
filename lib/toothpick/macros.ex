defmodule Toothpick.Macros do
  use Toothpick.Constants

  defmacro tokenize(name) do
    Enum.map(get(name), fn symbol -> create(name, symbol) end)
  end

  defp create(name, symbol) do
    quote do
      def tokens(unquote(symbol) <> tail), do: [{unquote(name), unquote(symbol)}] ++ tokens(tail)
    end
  end
end
