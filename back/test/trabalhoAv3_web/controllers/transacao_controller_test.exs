defmodule TrabalhoAv3Web.TransacaoControllerTest do
  use TrabalhoAv3Web.ConnCase

  import TrabalhoAv3.FinanceiroFixtures

  alias TrabalhoAv3.Financeiro.Transacao

  @create_attrs %{
    data: ~U[2025-06-02 19:38:00Z],
    descricao: "some descricao",
    valor: "120.5",
    tipo: "some tipo"
  }
  @update_attrs %{
    data: ~U[2025-06-03 19:38:00Z],
    descricao: "some updated descricao",
    valor: "456.7",
    tipo: "some updated tipo"
  }
  @invalid_attrs %{data: nil, descricao: nil, valor: nil, tipo: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all transacoes", %{conn: conn} do
      conn = get(conn, ~p"/api/transacoes")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transacao" do
    test "renders transacao when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/transacoes", transacao: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/transacoes/#{id}")

      assert %{
               "id" => ^id,
               "data" => "2025-06-02T19:38:00Z",
               "descricao" => "some descricao",
               "tipo" => "some tipo",
               "valor" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/transacoes", transacao: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update transacao" do
    setup [:create_transacao]

    test "renders transacao when data is valid", %{conn: conn, transacao: %Transacao{id: id} = transacao} do
      conn = put(conn, ~p"/api/transacoes/#{transacao}", transacao: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/transacoes/#{id}")

      assert %{
               "id" => ^id,
               "data" => "2025-06-03T19:38:00Z",
               "descricao" => "some updated descricao",
               "tipo" => "some updated tipo",
               "valor" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, transacao: transacao} do
      conn = put(conn, ~p"/api/transacoes/#{transacao}", transacao: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete transacao" do
    setup [:create_transacao]

    test "deletes chosen transacao", %{conn: conn, transacao: transacao} do
      conn = delete(conn, ~p"/api/transacoes/#{transacao}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/transacoes/#{transacao}")
      end
    end
  end

  defp create_transacao(_) do
    transacao = transacao_fixture()
    %{transacao: transacao}
  end
end
