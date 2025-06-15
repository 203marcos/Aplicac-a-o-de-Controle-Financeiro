defmodule TrabalhoAv3.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TrabalhoAv3.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        inserted_at: ~U[2025-06-01 22:10:00Z],
        name: "some name",
        password_hash: "some password_hash",
        updated_at: ~U[2025-06-01 22:10:00Z]
      })
      |> TrabalhoAv3.Accounts.create_user()

    user
  end
end
