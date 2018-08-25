defmodule Its.Issue.Ticket do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tickets" do
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
    |> cast(attrs, [:title, :priority, :category, :status, :description])
    |> validate_required([:title, :priority, :category, :status, :description])
  end
end
