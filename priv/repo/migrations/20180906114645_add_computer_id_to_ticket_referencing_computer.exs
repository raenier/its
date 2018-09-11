defmodule Its.Repo.Migrations.AddComputerIdToTicketReferencingComputer do
  use Ecto.Migration

  def change do
    alter table(:tickets) do
      add :computer_id, references(:computers, on_delete: :nilify_all)
    end

    create index(:tickets, [:computer_id])
  end
end
