defmodule ItsWeb.ClientController do
  use ItsWeb, :controller

  alias Its.Issue

  def index(conn, _params) do
    tickets = Issue.list_tickets()
    IO.inspect tickets
    render conn, "index.html", tickets: tickets
  end
end
