defmodule Its.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :first_name, :string
      add :middle_name, :string
      add :last_name, :string
      add :password, :string
      add :type, :string

      timestamps()
    end

    create unique_index(:users, [:username])
  end
end
