defmodule Its.Repo.Migrations.AddTechIdToTicketReferencingUsers do
  use Ecto.Migration

  def change do
    alter table(:tickets) do
      add :tech_id, references(:users, on_delete: :nilify_all)
    end

    create index(:tickets, [:tech_id])
  end
end
