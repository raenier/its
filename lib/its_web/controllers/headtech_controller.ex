defmodule ItsWeb.HeadtechController  do
  use ItsWeb, :controller
  require Ecto.Query

  alias Ecto.Query
  alias Its.Issue
  alias Its.Issue.Ticket
  alias Its.Accounts

  def index(conn, params) do
    tickets =
      Ticket
      |> Query.where([t], t.status !=4 and t.status == 1)
      |> Its.Repo.paginate(params)

    name_and_id = Accounts.map_name_id(["headtech", "technician"])
    render(conn, "index.html", tickets: tickets, name_and_id: name_and_id)
  end

  def assign(conn, %{"id" => id, "ticket" => attrs}) do
    ticket = Issue.get_ticket! id
    case Issue.assign_tech_and_update_status(ticket, attrs) do
      {:ok, ticket} ->
        conn
        |> redirect(to: headtech_path(conn, :index))

      {:error, Changeset} ->
        conn
        |> redirect(to: headtech_path(conn, :index))
    end
  end

  def tasks(conn, params) do
    user_id = get_session(conn, :current_user_id)
    tickets =
      Ticket
      |> Query.where([t], t.status == 2 and t.tech_id == ^user_id)
      |> Its.Repo.paginate(params)

    name_and_id = Accounts.map_name_id(["headtech", "technician"])
    render(conn, "index.html", tickets: tickets, name_and_id: name_and_id)
  end
end
