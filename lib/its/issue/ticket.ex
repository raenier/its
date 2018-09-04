defmodule Its.Issue.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  alias Its.Accounts.User

  schema "tickets" do
    belongs_to :client, User
    belongs_to :tech, User

    field :category, :string
    field :priority, :integer, default: 3
    field :status, :integer, default: 1
    field :title, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:title, :priority, :category, :status, :description, :client_id, :tech_id])
    |> validate_required([:title, :priority, :category, :status, :description])
  end
end
