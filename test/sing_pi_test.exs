defmodule SingPiTest do
  use ExUnit.Case
  doctest SingPi

  test "greets the world" do
    assert SingPi.hello() == :world
  end
end
