defmodule TrabalhoAv3.FinanceiroTest do
  use TrabalhoAv3.DataCase

  alias TrabalhoAv3.Financeiro

  describe "transacoes" do
    alias TrabalhoAv3.Financeiro.Transacao

    import TrabalhoAv3.FinanceiroFixtures

    @invalid_attrs %{data: nil, descricao: nil, valor: nil, tipo: nil}

    test "list_transacoes/0 returns all transacoes" do
      transacao = transacao_fixture()
      assert Financeiro.list_transacoes() == [transacao]
    end

    test "get_transacao!/1 returns the transacao with given id" do
      transacao = transacao_fixture()
      assert Financeiro.get_transacao!(transacao.id) == transacao
    end

    test "create_transacao/1 with valid data creates a transacao" do
      valid_attrs = %{data: ~U[2025-06-02 19:38:00Z], descricao: "some descricao", valor: "120.5", tipo: "some tipo"}

      assert {:ok, %Transacao{} = transacao} = Financeiro.create_transacao(valid_attrs)
      assert transacao.data == ~U[2025-06-02 19:38:00Z]
      assert transacao.descricao == "some descricao"
      assert transacao.valor == Decimal.new("120.5")
      assert transacao.tipo == "some tipo"
    end

    test "create_transacao/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financeiro.create_transacao(@invalid_attrs)
    end

    test "update_transacao/2 with valid data updates the transacao" do
      transacao = transacao_fixture()
      update_attrs = %{data: ~U[2025-06-03 19:38:00Z], descricao: "some updated descricao", valor: "456.7", tipo: "some updated tipo"}

      assert {:ok, %Transacao{} = transacao} = Financeiro.update_transacao(transacao, update_attrs)
      assert transacao.data == ~U[2025-06-03 19:38:00Z]
      assert transacao.descricao == "some updated descricao"
      assert transacao.valor == Decimal.new("456.7")
      assert transacao.tipo == "some updated tipo"
    end

    test "update_transacao/2 with invalid data returns error changeset" do
      transacao = transacao_fixture()
      assert {:error, %Ecto.Changeset{}} = Financeiro.update_transacao(transacao, @invalid_attrs)
      assert transacao == Financeiro.get_transacao!(transacao.id)
    end

    test "delete_transacao/1 deletes the transacao" do
      transacao = transacao_fixture()
      assert {:ok, %Transacao{}} = Financeiro.delete_transacao(transacao)
      assert_raise Ecto.NoResultsError, fn -> Financeiro.get_transacao!(transacao.id) end
    end

    test "change_transacao/1 returns a transacao changeset" do
      transacao = transacao_fixture()
      assert %Ecto.Changeset{} = Financeiro.change_transacao(transacao)
    end
  end

  describe "tags" do
    alias TrabalhoAv3.Financeiro.Tag

    import TrabalhoAv3.FinanceiroFixtures

    @invalid_attrs %{nome: nil}

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Financeiro.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Financeiro.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_attrs = %{nome: "some nome"}

      assert {:ok, %Tag{} = tag} = Financeiro.create_tag(valid_attrs)
      assert tag.nome == "some nome"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financeiro.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      update_attrs = %{nome: "some updated nome"}

      assert {:ok, %Tag{} = tag} = Financeiro.update_tag(tag, update_attrs)
      assert tag.nome == "some updated nome"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Financeiro.update_tag(tag, @invalid_attrs)
      assert tag == Financeiro.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Financeiro.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Financeiro.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Financeiro.change_tag(tag)
    end
  end
end
