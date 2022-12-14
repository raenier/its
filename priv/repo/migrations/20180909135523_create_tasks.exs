defmodule Its.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :description, :string
      add :ticket_id, references(:tickets, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end

    create index(:tasks, [:ticket_id, :user_id])
  end
end
