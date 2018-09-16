defmodule Its.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Its.Issue.Ticket
  alias Its.Devices.Computer


  schema "users" do
    has_many :assigned_tickets, Ticket, on_delete: :nilify_all, foreign_key: :htech_id
    has_many :created_tickets, Ticket, on_delete: :nilify_all, foreign_key: :client_id
    has_many :owned_tickets, Ticket, on_delete: :nilify_all, foreign_key: :tech_id
    has_many :computers, Computer, on_delete: :nilify_all

    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string, default: ""
    field :password, :string
    field :type, :string
    field :username, :string
    field :password_confirm, :string, virtual: true
    field :ol_status, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :first_name, :middle_name, :last_name, :password, :type, :ol_status])
    |> validate_required([:username, :first_name, :last_name, :password, :type])
    |> unique_constraint(:username)
  end
end
