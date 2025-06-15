defmodule TrabalhoAv3.Financeiro.Transacao do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transacoes" do
    field :data, :utc_datetime
    field :descricao, :string
    field :valor, :decimal
    field :tipo, :string

    belongs_to :usuario, TrabalhoAv3.Accounts.User, foreign_key: :usuario_id
    many_to_many :tags, TrabalhoAv3.Financeiro.Tag, join_through: "transacoes_tags", on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transacao, attrs) do
    attrs =
      case attrs["data"] do
        <<_::binary-size(10)>> = date_str -> Map.put(attrs, "data", date_str <> "T00:00:00Z")
        _ -> attrs
      end

    transacao
    |> cast(attrs, [:descricao, :valor, :tipo, :data, :usuario_id])
    |> validate_required([:descricao, :valor, :tipo, :data, :usuario_id])
    |> maybe_cast_tags(attrs)
  end

  # Só faz o cast das tags se o campo estiver presente nos parâmetros
  defp maybe_cast_tags(changeset, %{"tags" => _tags}) do
    cast_assoc(changeset, :tags)
  end

  defp maybe_cast_tags(changeset, _attrs), do: changeset
end
