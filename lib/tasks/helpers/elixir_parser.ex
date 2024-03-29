defmodule Tasks.Helpers.ElixirParser do
  def parse(str) when is_binary(str) do
    case str |> Code.string_to_quoted() do
      {:ok, terms} -> _parse(terms)
      {:error, _} -> {:invalid_terms}
    end
  end

  # atomic terms
  defp _parse(term) when is_atom(term), do: term
  defp _parse(term) when is_integer(term), do: term
  defp _parse(term) when is_float(term), do: term
  defp _parse(term) when is_binary(term), do: term

  defp _parse([]), do: []
  defp _parse([h | t]), do: [_parse(h) | _parse(t)]

  defp _parse({a, b}), do: {_parse(a), _parse(b)}

  defp _parse({:{}, _place, terms}) do
    terms
    |> Enum.map(&_parse/1)
    |> List.to_tuple()
  end

  defp _parse({:%{}, _place, terms}) do
    for {k, v} <- terms, into: %{}, do: {_parse(k), _parse(v)}
  end

  # to ignore functions and operators
  defp _parse({_term_type, _place, terms}), do: terms
end
