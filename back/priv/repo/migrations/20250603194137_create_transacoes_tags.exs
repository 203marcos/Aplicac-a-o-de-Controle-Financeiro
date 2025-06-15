# filepath: priv/repo/migrations/20250603194137_create_transacoes_tags.exs
defmodule TrabalhoAv3.Repo.Migrations.CreateTransacoesTags do
  use Ecto.Migration

  def change do
    create table(:transacoes_tags, primary_key: false) do
      add :transacao_id, references(:transacoes, on_delete: :delete_all)
      add :tag_id, references(:tags, on_delete: :delete_all)
    end

    create unique_index(:transacoes_tags, [:transacao_id, :tag_id])
  end
end
