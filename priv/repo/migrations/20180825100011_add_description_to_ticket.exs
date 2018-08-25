defmodule Its.Repo.Migrations.AddDescriptionToTicket do
  use Ecto.Migration

  def change do
    alter table(:tickets) do
      add :description, :string
    end
  end
end
