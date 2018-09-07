defmodule Its.Repo.Migrations.AddComputerIdToTicketReferencingComputer do
  use Ecto.Migration

  def change do
    alter table(:tickets) do
      add :device_id, references(:computers, on_delete: :nothing)
    end

    create index(:tickets, [:device_id])
  end
end
