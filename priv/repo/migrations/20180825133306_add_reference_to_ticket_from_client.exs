defmodule Its.Repo.Migrations.AddReferenceToTicketFromClient do
  use Ecto.Migration

  def change do
    alter table(:tickets) do
      add :client_id, references(:users, on_delete: :nilify_all)
    end

    create index(:tickets, [:client_id])
  end
end
