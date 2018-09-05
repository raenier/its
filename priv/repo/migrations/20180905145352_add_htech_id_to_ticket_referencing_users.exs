defmodule Its.Repo.Migrations.AddHtechIdToTicketReferencingUsers do
  use Ecto.Migration

  def change do
    alter table(:tickets) do
      add :htech_id, references(:users, on_delete: :nothing)
      add :progress, :integer
    end

    create index(:tickets, [:htech_id])
  end
end
