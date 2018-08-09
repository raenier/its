defmodule ItsWeb.AdminController do
  use ItsWeb, :controller

  alias Its.Accounts

  def index(conn, _params) do
    users = Accounts.list_users()
    changeset = Accounts.change_user(%Accounts.User{})
    render conn, "index.html", users: users, changeset: changeset
  end
end
