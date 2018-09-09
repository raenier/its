defmodule Its.Issue.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias Its.Issue.Ticket
  alias Its.Accounts.User


  schema "tasks" do
    belongs_to :ticket, Ticket
    belongs_to :user, User

    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:description, :ticket_id, :user_id])
    |> validate_required([:description])
  end
end
