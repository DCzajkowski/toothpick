defmodule Toothpick.Macros do
  use Toothpick.Constants

  @doc """
  Creates functions tokens() for each symbol in symbols argument

  name (atom) - name to be used for symbol identification
  symbols (atom) - symbols to be retrieved from the Toothpick.Constants module
  """
  defmacro tokens(name, symbols) do
    Enum.map(get(symbols), fn symbol -> create(name, symbol) end)
  end

  defp create(name, symbol) do
    quote do
      def tokens(unquote(symbol) <> tail), do: [{unquote(name), unquote(symbol)}] ++ tokens(tail)
    end
  end
end
