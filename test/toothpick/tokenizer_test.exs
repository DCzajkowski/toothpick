defmodule TokenizerTest do
  import Toothpick.Tokenizer, only: [tokens: 1]
  use Snapshy
  use ExUnit.Case

  doctest Toothpick.Tokenizer

  defp stub(filename) do
    File.cwd!()
    |> Path.join("/test/stubs/#{filename}.tp")
    |> File.read!()
  end

  test_snapshot "correctly tokenizes booleans" do
    tokens("true false")
  end

  test_snapshot "correctly tokenizes function without arguments" do
    tokens(stub("function_without_arguments"))
  end

  test_snapshot "correctly tokenizes function with arguments" do
    tokens(stub("function_with_arguments"))
  end

  test_snapshot "correctly tokenizes function with multiline arguments" do
    tokens(stub("function_with_multiline_arguments"))
  end

  test_snapshot "correctly tokenizes multiple advanced functions" do
    tokens(stub("fibonacci"))
  end

  test_snapshot "correctly tokenizes if statement with no else clauses" do
    tokens("""
    if @a :
      return 1
    .
    """)
  end

  test_snapshot "correctly tokenizes if statement with else clauses" do
    tokens("""
    if
      @a : return 1
      cond(@a, 4) : return 2
      true : return 3
    .
    """)
  end
end
