defmodule Its.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add :title, :string
      add :priority, :integer
      add :category, :string
      add :status, :integer

      timestamps()
    end

  end
end
