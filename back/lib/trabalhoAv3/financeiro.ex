defmodule TrabalhoAv3.Financeiro do
  @moduledoc """
  The Financeiro context.
  """

  import Ecto.Query, warn: false
  alias TrabalhoAv3.Repo

  alias TrabalhoAv3.Financeiro.Transacao

  @doc """
  Returns the list of transacoes.

  ## Examples

      iex> list_transacoes()
      [%Transacao{}, ...]

  """
  def list_transacoes do
    Repo.all(Transacao) |> Repo.preload(:tags)
  end

  @doc """
  Gets a single transacao.

  Raises `Ecto.NoResultsError` if the Transacao does not exist.

  ## Examples

      iex> get_transacao!(123)
      %Transacao{}

      iex> get_transacao!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transacao!(id), do: Repo.get!(Transacao, id) |> Repo.preload(:tags)

  @doc """
  Creates a transacao.

  ## Examples

      iex> create_transacao(%{field: value})
      {:ok, %Transacao{}}

      iex> create_transacao(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transacao(attrs \\ %{}) do
    tag_ids =
      case Map.get(attrs, "tag_ids", []) do
        ids when is_list(ids) -> Enum.map(ids, &parse_int/1)
        id when is_binary(id) -> [parse_int(id)]
        _ -> []
      end

    tags = if tag_ids == [], do: [], else: Repo.all(from t in TrabalhoAv3.Financeiro.Tag, where: t.id in ^tag_ids)
    attrs = Map.delete(attrs, "tag_ids")

    %Transacao{}
    |> Transacao.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, tags)
    |> Repo.insert()
  end

  defp parse_int(val) when is_integer(val), do: val
  defp parse_int(val) when is_binary(val), do: String.to_integer(val)

  @doc """
  Updates a transacao.

  ## Examples

      iex> update_transacao(transacao, %{field: new_value})
      {:ok, %Transacao{}}

      iex> update_transacao(transacao, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transacao(%Transacao{} = transacao, attrs) do
    {attrs, changeset_fun} =
      case Map.pop(attrs, "tag_ids") do
        {nil, attrs} ->
          {attrs, fn ch -> ch end}

        {tag_ids, attrs} ->
          tag_ids = if is_list(tag_ids), do: tag_ids, else: [tag_ids]
          tags = if tag_ids == [], do: [], else: Repo.all(from t in TrabalhoAv3.Financeiro.Tag, where: t.id in ^tag_ids)
          {attrs, fn ch -> Ecto.Changeset.put_assoc(ch, :tags, tags) end}
      end

    transacao
    |> Transacao.changeset(attrs)
    |> changeset_fun.()
    |> Repo.update()
  end

  @doc """
  Deletes a transacao.

  ## Examples

      iex> delete_transacao(transacao)
      {:ok, %Transacao{}}

      iex> delete_transacao(transacao)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transacao(%Transacao{} = transacao) do
    Repo.delete(transacao)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transacao changes.

  ## Examples

      iex> change_transacao(transacao)
      %Ecto.Changeset{data: %Transacao{}}

  """
  def change_transacao(%Transacao{} = transacao, attrs \\ %{}) do
    Transacao.changeset(transacao, attrs)
  end

  alias TrabalhoAv3.Financeiro.Tag

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
  def list_tags do
    Repo.all(Tag)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{data: %Tag{}}

  """
  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end

  def list_tags_by_usuario(usuario_id) do
    Repo.all(from t in TrabalhoAv3.Financeiro.Tag, where: t.usuario_id == ^usuario_id)
  end
end
