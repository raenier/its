defmodule Its.Issue.Ticket do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tickets" do
    field :category, :string
    field :priority, :integer
    field :status, :integer
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:title, :priority, :category, :status])
    |> validate_required([:title, :priority, :category, :status])
  end
end
