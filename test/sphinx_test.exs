defmodule SphinxTest do
  use ExUnit.Case
  doctest Sphinx

  test "greets the world" do
    assert Sphinx.hello() == :world
  end
end
