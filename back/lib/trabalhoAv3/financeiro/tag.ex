defmodule TrabalhoAv3.Financeiro.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :nome, :string

    belongs_to :usuario, TrabalhoAv3.Accounts.User, foreign_key: :usuario_id
    many_to_many :transacoes, TrabalhoAv3.Financeiro.Transacao, join_through: "transacoes_tags"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:nome])
    |> validate_required([:nome])
  end
end
