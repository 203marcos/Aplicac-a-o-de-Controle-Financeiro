defmodule TrabalhoAv3.FinanceiroFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TrabalhoAv3.Financeiro` context.
  """

  @doc """
  Generate a transacao.
  """
  def transacao_fixture(attrs \\ %{}) do
    {:ok, transacao} =
      attrs
      |> Enum.into(%{
        data: ~U[2025-06-02 19:38:00Z],
        descricao: "some descricao",
        tipo: "some tipo",
        valor: "120.5"
      })
      |> TrabalhoAv3.Financeiro.create_transacao()

    transacao
  end

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        nome: "some nome"
      })
      |> TrabalhoAv3.Financeiro.create_tag()

    tag
  end
end
