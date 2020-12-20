defmodule PasswordTest do
  use ExUnit.Case
  doctest Password

  describe "Password.hash/1" do
    test "hashes a password" do
      assert is_binary(Password.hash("Foobar"))
    end
  end

  describe "Password.check/2" do
    test "map/struct with password_hash and correct password returns true" do
      password = Faker.Lorem.characters() |> to_string()
      hash = Password.hash(password)
      assert Password.check(%{password_hash: hash}, password)
    end

    test "checking a string returns true" do
      password = Faker.Lorem.characters() |> to_string()
      hash = Password.hash(password)
      assert Password.check(hash, password)
    end

    test "an incorrect hash in map returns false" do
      hash = Faker.Lorem.characters()
        |> to_string()
        |> Password.hash()
      assert Password.check(%{password_hash: hash}, Faker.Lorem.characters()) == false
    end

    test "an incorrect string returns false" do
      hash = Faker.Lorem.characters()
        |> to_string()
        |> Password.hash()
      assert Password.check(hash, Faker.Lorem.characters()) == false
    end
  end

  describe "Password.is_strong_password?/1" do
    test "strong password is strong" do
      assert Password.is_strong_password?("ONEtwo333$$$")
    end

    test "random strong password is strong" do
      password = "Aa1$#{Faker.Currency.symbol()}#{Faker.Lorem.characters() |> to_string()}"
      assert Password.is_strong_password?(password)
    end

    test "short password is not strong" do
      assert !Password.is_strong_password?(Faker.Lorem.characters(1..11) |> to_string())
    end
  end
end
