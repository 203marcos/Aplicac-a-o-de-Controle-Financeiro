defmodule TrabalhoAv3Web.TagJSON do
  alias TrabalhoAv3.Financeiro.Tag

  @doc """
  Renders a list of tags.
  """
  def index(%{tags: tags}) do
    %{data: for(tag <- tags, do: data(tag))}
  end

  @doc """
  Renders a single tag.
  """
  def show(%{tag: tag}) do
    %{data: data(tag)}
  end

  def transacoes(%{transacoes: transacoes}) do
    %{data: Enum.map(transacoes, fn transacao ->
      %{
        id: transacao.id,
        descricao: transacao.descricao,
        valor: transacao.valor,
        tipo: transacao.tipo,
        data: transacao.data
      }
    end)}
  end

  defp data(%Tag{} = tag) do
    %{
      id: tag.id,
      nome: tag.nome
    }
  end
end
