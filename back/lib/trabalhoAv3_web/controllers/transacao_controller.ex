defmodule TrabalhoAv3Web.TransacaoController do
  use TrabalhoAv3Web, :controller

  alias TrabalhoAv3.Financeiro
  alias TrabalhoAv3.Financeiro.Transacao

  action_fallback TrabalhoAv3Web.FallbackController

  def index(conn, %{"usuario_id" => usuario_id}) do
  transacoes = Financeiro.list_transacoes()
    |> Enum.filter(&(&1.usuario_id == String.to_integer(usuario_id)))
  render(conn, :index, transacoes: transacoes)
  end

  def index(conn, _params) do
    transacoes = Financeiro.list_transacoes()
    render(conn, :index, transacoes: transacoes)
  end

  def create(conn, %{"transacao" => transacao_params}) do
    params = normalize_data(transacao_params)

    with {:ok, %Transacao{} = transacao} <- Financeiro.create_transacao(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/transacoes/#{transacao}")
      |> render(:show, transacao: transacao)
    end
  end

  def create(conn, params) do
    create(conn, %{"transacao" => params})
  end

  def show(conn, %{"id" => id}) do
    transacao = Financeiro.get_transacao!(id)
    render(conn, :show, transacao: transacao)
  end

  def update(conn, %{"id" => id, "transacao" => transacao_params}) do
    transacao = Financeiro.get_transacao!(id)
    params = normalize_data(transacao_params)

    with {:ok, %Transacao{} = transacao} <- Financeiro.update_transacao(transacao, params) do
      render(conn, :show, transacao: transacao)
    end
  end

  def update(conn, %{"id" => id} = params) do
    transacao_params = Map.get(params, "transacao", params)
    update(conn, %{"id" => id, "transacao" => transacao_params})
  end

  def delete(conn, %{"id" => id}) do
    transacao = Financeiro.get_transacao!(id)

    with {:ok, %Transacao{}} <- Financeiro.delete_transacao(transacao) do
      send_resp(conn, :no_content, "")
    end
  end

  defp normalize_data(params) do
    case Map.get(params, "data") do
      nil -> params

      data_str ->
        # Tenta converter "YYYY-MM-DD" ou "YYYY-MM-DD HH:MM"
        case NaiveDateTime.from_iso8601(data_str <> ":00") do
          {:ok, naive_dt} -> Map.put(params, "data", naive_dt)

          _ ->
            case NaiveDateTime.from_iso8601(data_str) do
              {:ok, naive_dt} -> Map.put(params, "data", naive_dt)
              _ -> params # Se não conseguir converter, mantém original
            end
        end
    end
  end


end
