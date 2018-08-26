defmodule ItsWeb.ClientController do
  use ItsWeb, :controller

  alias Its.Issue
  alias Its.Issue.Ticket

  def index(conn, _params) do
    user_id = get_session(conn, :current_user_id)
    tickets = Issue.list_tickets_for_user(user_id)
    changeset = Issue.change_ticket(%Issue.Ticket{})
    render conn, "index.html", tickets: tickets, changeset: changeset
  end

  def create(conn, %{"ticket" => ticket}) do
    client_id = get_session(conn, :current_user_id)
    ticket =
    Map.put(ticket, "client_id", client_id)

    case Issue.create_ticket(ticket) do
      {:ok, ticket} ->
        conn
        |> redirect(to: client_path(conn, :index))
      {:error, changeset} ->
        conn
        |> redirect(to: client_path(conn, :index))
    end
  end
end
