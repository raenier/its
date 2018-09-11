defmodule Its.Issue.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  alias Its.Accounts.User
  alias Its.Devices.Computer
  alias Its.Issue.Task

  schema "tickets" do
    belongs_to :client, User
    belongs_to :tech, User
    belongs_to :htech, User
    belongs_to :computer, Computer
    has_many :tasks, Task

    field :category, :string
    field :priority, :integer, default: 3
    field :status, :integer, default: 1
    field :title, :string
    field :description, :string
    field :progress, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:title, :priority, :category, :status, :description, :client_id, :tech_id, :htech_id, :computer_id, :progress])
    |> validate_required([:title, :priority, :category, :status, :description])
  end
end
