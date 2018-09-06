defmodule Its.Repo.Migrations.AddUserToDeviceReferenceFromUser do
  use Ecto.Migration

  def change do
    alter table(:computers) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:computers, [:user_id])
  end
end
