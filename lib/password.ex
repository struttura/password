defmodule Password do
  @moduledoc """
  Documentation for `Password`.
  """
  require Ecto.Changeset
  import Ecto.Changeset

  @error_message "Password is too short, must be at least 12 characters, with at least one: upper and lower-case letter, a symbol, and a number"

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

  def validate_password_format(changeset) do
    validate_change(changeset, :password, fn _, value ->
      case is_strong_password?(value) do
        true ->
          []

        false ->
          [
            {:password,
             """
             Invalid password format.
             Password must be at least 12 characters, have 1 uppercase letter,
             1 lowercase letter, 1 symbol, and 1 number.
             """}
          ]
      end
    end)
  end

  def put_password_hash(changeset) do
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

    true
  end

  defp is_long?(password) do
    if String.length(password) >= 12 do
      password
    else
      raise @error_message
    end
  end

  defp has_regex?(password, regex) do
    if Regex.match?(regex, password) do
      password
    else
      raise @error_message
    end
  end
end

