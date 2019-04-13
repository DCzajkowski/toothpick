defmodule ToothpickTokenizerTest do
  use ExUnit.Case
  doctest Toothpick.Tokenizer

  test "correctly tokenizes simple syntax string" do
    assert Toothpick.Tokenizer.tokens("hello world") == ["hello", "world"]
  end
end
