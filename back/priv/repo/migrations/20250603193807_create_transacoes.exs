defmodule TrabalhoAv3.Repo.Migrations.CreateTransacoes do
  use Ecto.Migration

  def change do
    create table(:transacoes) do
      add :descricao, :string
      add :valor, :decimal
      add :tipo, :string
      add :data, :utc_datetime
      add :usuario_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:transacoes, [:usuario_id])
  end
end
