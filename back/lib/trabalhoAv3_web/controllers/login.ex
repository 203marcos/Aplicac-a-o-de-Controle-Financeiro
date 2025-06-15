defmodule TrabalhoAv3Web.SessionController do
  use TrabalhoAv3Web, :controller

  alias TrabalhoAv3.Accounts
  alias TrabalhoAv3Web.Auth.Guardian

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        json(conn, %{token: token, user: %{id: user.id, email: user.email}})
      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})
    end
  end
end
