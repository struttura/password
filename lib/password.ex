defmodule Password do
  @moduledoc """
  Documentation for `Password`.
  """
  require Ecto.Changeset
  import Ecto.Changeset

  @invalid_password_error "Password is too short, must be at least 12 characters, with at least one: upper and lower-case letter, a symbol, and a number"

  def invalid_password_error(), do: @invalid_password_error

  def hash(password) do
    Argon2.Base.hash_password(password, Argon2.gen_salt())
  end

  def check(hash, password) when is_binary(hash) do
    %{password_hash: hash}
    |> check(password)
  end

  def check(%{password_hash: _} = map, password) do
    Argon2.check_pass(map, password)
    |> case do
      {:ok, _} -> true
      _ -> false
    end
  end

  def validate_password_format(%Ecto.Changeset{} = changeset) do
    validate_change(changeset, :password, fn _, value ->
      case is_strong_password?(value) do
        true ->
          []

        false ->
          [
            {:password,

             """
             Invalid password format.
             #{@invalid_password_error}
             """}
          ]
      end
    end)
  end

  def put_password_hash(%Ecto.Changeset{} = changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(
          changeset,
          :password_hash,
          hash(pass)
        )

      _ ->
        changeset
    end
  end

  def is_strong_password?(password) do
    password
    |> is_long?()
    |> has_regex?(~r/[[:punct:]]/)
    |> has_regex?(~r/[[:lower:]]/)
    |> has_regex?(~r/[[:upper:]]/)
    |> has_regex?(~r/[[:digit:]]/)
  end

  defp is_long?(password) do
    if String.length(password) >= 12 do
      password
    else
      false
    end
  end

  defp has_regex?(false, _), do: false
  defp has_regex?(password, regex) do
    if Regex.match?(regex, password) do
      password
    else
      false
    end
  end
end

