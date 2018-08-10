defmodule ItsWeb.AdminController do
  use ItsWeb, :controller

  alias Its.Accounts

  def index(conn, _params) do
    users = Accounts.list_users()
    changeset = Accounts.change_user(%Accounts.User{})
    typeselection = [client: "client", technician: "tech"]
    render conn, "index.html", users: users, changeset: changeset, typeselection: typeselection
  end

  def create(conn, %{"user" => attrs}) do
    case Accounts.create_user(attrs) do
      {:ok, user} ->
        conn
        |> redirect(to: admin_path(conn, :index))
      {:error, changeset} ->
        conn
        |> redirect(to: admin_path(conn, :index))
    end
  end

  def delete(conn, %{ "id" => id }) do
    user = Accounts.get_user! id
    case Accounts.delete_user(user) do
      {:ok, user} ->
        conn
        |> redirect(to: admin_path(conn, :index))
    end
  end
end
