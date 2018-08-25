defmodule ItsWeb.ClientController do
  use ItsWeb, :controller

  alias Its.Issue
  alias Its.Issue.Ticket

  def index(conn, _params) do
    tickets = Issue.list_tickets()
    changeset = Issue.change_ticket(%Issue.Ticket{})
    render conn, "index.html", tickets: tickets, changeset: changeset
  end

  def create(conn, %{"ticket" => ticket}) do
    case Issue.create_ticket(ticket) do
      {:ok, ticket} ->
        conn
        |> redirect(to: client_path(conn, :index))
      {:error, changeset} ->
        IO.inspect changeset
        conn
        |> redirect(to: client_path(conn, :index))
    end
  end
end
