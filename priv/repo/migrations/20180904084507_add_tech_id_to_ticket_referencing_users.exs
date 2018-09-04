defmodule Its.Repo.Migrations.AddTechIdToTicketReferencingUsers do
  use Ecto.Migration

  def change do
    alter table(:tickets) do
      add :tech_id, references(:users, on_delete: :nothing)
    end

    create index(:tickets, [:tech_id])
  end
end
