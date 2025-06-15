defmodule TrabalhoAv3Web.TagController do
  use TrabalhoAv3Web, :controller

  alias TrabalhoAv3.Financeiro
  alias TrabalhoAv3.Financeiro.Tag

  action_fallback TrabalhoAv3Web.FallbackController

  def index(conn, _params) do
    tags = Financeiro.list_tags()
    render(conn, :index, tags: tags)
  end

  def create(conn, %{"tag" => tag_params}) do
    with {:ok, %Tag{} = tag} <- Financeiro.create_tag(tag_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/tags/#{tag}")
      |> render(:show, tag: tag)
    end
  end

  def create(conn, params) do
    # aceita params diretos (sem a chave "user")
    create(conn, %{"tag" => params})
  end

  def show(conn, %{"id" => id}) do
    tag = Financeiro.get_tag!(id)
    render(conn, :show, tag: tag)
  end

  def update(conn, %{"id" => id, "tag" => tag_params}) do
    tag = Financeiro.get_tag!(id)

    with {:ok, %Tag{} = tag} <- Financeiro.update_tag(tag, tag_params) do
      render(conn, :show, tag: tag)
    end
  end

  def update(conn, %{"id" => id} = params) do
  tag_params = Map.get(params, "tag", params)
  update(conn, %{"id" => id, "tag" => tag_params})
  end

  def delete(conn, %{"id" => id}) do
    tag = Financeiro.get_tag!(id)

    with {:ok, %Tag{}} <- Financeiro.delete_tag(tag) do
      send_resp(conn, :no_content, "")
    end
  end

  def transacoes(conn, %{"id" => id}) do
    tag = Financeiro.get_tag!(id) |> TrabalhoAv3.Repo.preload(:transacoes)
    render(conn, "transacoes.json", transacoes: tag.transacoes)
  end

  def tags(conn, %{"id" => id}) do
  user = TrabalhoAv3.Accounts.get_user!(id) |> TrabalhoAv3.Repo.preload(:tags)
  render(conn, "tags.json", tags: user.tags)
  end

  def tags_by_user(conn, %{"iduser" => iduser}) do
  tags = TrabalhoAv3.Financeiro.list_tags_by_usuario(iduser)
  render(conn, "index.json", tags: tags)
  end
end
