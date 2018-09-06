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
    active_tab = 1
    name_and_id = Accounts.map_name_id(["headtech", "technician"])
    render(conn, "index.html", tickets: tickets, name_and_id: name_and_id, active_tab: active_tab)
  end

  def assign(conn, %{"id" => id, "ticket" => attrs}) do
    user_id = get_session(conn, :current_user_id)
    #also put htech_id to know who assigned the ticket
    attrs = Map.put(attrs, "htech_id", user_id)

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

    active_tab = 2
    name_and_id = Accounts.map_name_id(["headtech", "technician"])
    render(conn, "index.html", tickets: tickets, name_and_id: name_and_id, active_tab: active_tab)
  end

  def to_others(conn, params) do
    user_id = get_session(conn, :current_user_id)
    tickets =
      Ticket
      |> Query.where([t], t.htech_id == ^user_id and t.tech_id != ^user_id)
      |> Its.Repo.paginate(params)

    active_tab = 3
    name_and_id = Accounts.map_name_id(["headtech", "technician"])
    render(conn, "index.html", tickets: tickets, name_and_id: name_and_id, active_tab: active_tab)
  end
end
