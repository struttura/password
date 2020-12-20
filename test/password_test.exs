defmodule PasswordTest do
  use ExUnit.Case
  doctest Password

  test "greets the world" do
    assert Password.hello() == :world
  end
end
