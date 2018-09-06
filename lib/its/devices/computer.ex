defmodule Its.Devices.Computer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Its.Accounts.User


  schema "computers" do
    belongs_to :user, User

    field :graphics, :string
    field :model, :string
    field :os, :string
    field :processor, :string
    field :ram, :string
    field :type, :string
    field :softwares, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(computer, attrs) do
    computer
    |> cast(attrs, [:model, :os, :softwares, :processor, :ram, :graphics, :type, :user_id])
    |> validate_required([:model, :os, :type])
  end
end
