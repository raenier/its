defmodule ItsWeb.HeadtechController  do
  use ItsWeb, :controller
  require Ecto.Query

  alias Ecto.Query
  alias Its.Issue.Ticket

  def index(conn, params) do
    tickets =
      Ticket
      |> Query.where([t], t.status !=4 and t.status == 1)
      |> Its.Repo.paginate(params)

    render(conn, "index.html", tickets: tickets)
  end
end
