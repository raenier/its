defmodule ItsWeb.PageController do
  use ItsWeb, :controller
  alias Its.Accounts

  def index(conn, _params) do
    admin_count =
      ["admin"]
      |> Accounts.list_users_only
      |> Enum.count()

    render conn, "index.html", admin_count: admin_count
  end
end
