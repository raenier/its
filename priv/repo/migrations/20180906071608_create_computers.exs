defmodule Its.Repo.Migrations.CreateComputers do
  use Ecto.Migration

  def change do
    create table(:computers) do
      add :model, :string
      add :os, :string
      add :softwares, {:array, :string}
      add :processor, :string
      add :ram, :string
      add :graphics, :string
      add :type, :string

      timestamps()
    end

  end
end
