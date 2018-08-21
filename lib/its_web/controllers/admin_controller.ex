defmodule ItsWeb.AdminController do
  use ItsWeb, :controller

  alias Its.Accounts

  plug :check_admin_auth when action in [:index_all, :create, :delete, :update]

  defp check_admin_auth(conn, _args) do
    if user_id = get_session(conn, :current_user_id) do
      current_user = Accounts.get_user!(user_id)
      case current_user.type do
        "client" ->
          conn
          |> redirect(to: page_path(conn, :index))
          |> halt()

        "technician" ->
          conn
          |> redirect(to: page_path(conn, :index))
          |> halt()

        "admin" ->
          conn
          |> assign(:current_user, current_user)

        _ ->
          conn
          |> redirect(to: session_path(conn, :new))
          |> halt()
      end
    else
      conn
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end

  def index_all(conn, _params) do
    users = Accounts.list_users_except_admins()
    changeset = Accounts.change_user(%Accounts.User{})
    render conn, "index.html", users: users, changeset: changeset
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

  def update(conn, %{"id" => id, "user" => attrs}) do
    user = Accounts.get_user! id
    case Accounts.update_user(user, attrs) do
      {:ok, user} ->
        conn
        |> redirect(to: admin_path(conn, :index))

      {:error, _changest} ->
        conn
        |> redirect(to: admin_path(conn, :index))
    end
  end
end
