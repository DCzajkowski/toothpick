defmodule ToothpickTest do
  use ExUnit.Case
  doctest Toothpick

  test "greets the world" do
    assert Toothpick.hello() == :world
  end
end
