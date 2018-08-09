defmodule ItsWeb.AdminController do
  use ItsWeb, :controller

  alias Its.Accounts

  def index(conn, _params) do
    users = Accounts.list_users()
    render conn, "index.html", users: users
  end
end
