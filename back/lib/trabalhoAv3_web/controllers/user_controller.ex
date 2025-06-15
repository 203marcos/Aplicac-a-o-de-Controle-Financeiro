defmodule TrabalhoAv3Web.UserController do
  use TrabalhoAv3Web, :controller

  alias TrabalhoAv3.Accounts
  alias TrabalhoAv3.Accounts.User

  action_fallback TrabalhoAv3Web.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def create(conn, params) do
    # aceita params diretos (sem a chave "user")
    create(conn, %{"user" => params})
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
  user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def update(conn, %{"id" => id} = params) do
    user_params = Map.get(params, "user", params)
    update(conn, %{"id" => id, "user" => user_params})
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def tags(conn, %{"id" => id}) do
  user = Accounts.get_user!(id) |> TrabalhoAv3.Repo.preload(:tags)
  render(conn, :tags, tags: user.tags)
  end
end
