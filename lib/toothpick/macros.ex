defmodule Toothpick.Macros do
  defmacro tokenize(name, symbols) do
    Enum.map(symbols, fn symbol -> create(name, symbol) end)
  end

  defp create(name, symbol) do
    quote do
      def tokens(unquote(symbol) <> tail), do: [{unquote(name), unquote(symbol)}] ++ tokens(tail)
    end
  end
end
