defmodule Its.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :password, :string
    field :type, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :first_name, :middle_name, :last_name, :password, :type])
    |> validate_required([:username, :first_name, :last_name, :password, :type])
    |> unique_constraint(:username)
  end
end
