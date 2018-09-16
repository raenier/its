defmodule Its.Repo.Migrations.AddOlStatusToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :ol_status, :integer
    end
  end
end
