defmodule TrabalhoAv3Web.TransacaoJSON do
  alias TrabalhoAv3.Financeiro.Transacao

  @doc """
  Renders a list of transacoes.
  """
  def index(%{transacoes: transacoes}) do
    %{data: for(transacao <- transacoes, do: data(transacao))}
  end

  @doc """
  Renders a single transacao.
  """
  def show(%{transacao: transacao}) do
    %{data: data(transacao)}
  end

  defp data(%Transacao{} = transacao) do
    %{
      id: transacao.id,
      descricao: transacao.descricao,
      valor: transacao.valor,
      tipo: transacao.tipo,
      data: transacao.data,
      tags: Enum.map(transacao.tags || [], fn tag ->
        %{
          id: tag.id,
          nome: tag.nome
        }
      end)
    }
  end
end
