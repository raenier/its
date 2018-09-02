defmodule ItsWeb.AdminController do
  use ItsWeb, :controller

  alias Its.Accounts

  plug :check_admin_auth when action in [:index_all, :index_clients, :index_tech, :create, :delete, :update]

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
    users = Accounts.list_users_only(["client", "technician", "headtech"])
    changeset = Accounts.change_user(%Accounts.User{})
    active_tab = 1
    render conn, "index.html", users: users, changeset: changeset, active_tab: active_tab
  end

  def index_clients(conn, _params) do
    users = Accounts.list_users_only(["client"])
    changeset = Accounts.change_user(%Accounts.User{})
    active_tab = 2
    render conn, "index.html", users: users, changeset: changeset, active_tab: active_tab
  end

  def index_tech(conn, _params) do
    users = Accounts.list_users_only(["technician"])
    changeset = Accounts.change_user(%Accounts.User{})
    active_tab = 3
    render conn, "index.html", users: users, changeset: changeset, active_tab: active_tab
  end

  def create(conn, %{"user" => attrs}) do
    case Accounts.create_user(attrs) do
      {:ok, user} ->
        conn
        |> redirect(to: admin_path(conn, :index_all))
      {:error, changeset} ->
        conn
        |> redirect(to: admin_path(conn, :index_all))
    end
  end

  def delete(conn, %{ "id" => id ,"tab" => active_tab}) do
    user = Accounts.get_user! id
    case Accounts.delete_user(user) do
      {:ok, user} ->
        case active_tab do
          "1" ->
            conn
            |> redirect(to: admin_path(conn, :index_all))

          "2" ->
            conn
            |> redirect(to: admin_path(conn, :index_clients))

          "3" ->
            conn
            |> redirect(to: admin_path(conn, :index_tech))
        end
    end
  end

  def update(conn, %{"id" => id, "user" => attrs}) do
    user = Accounts.get_user! id
    case Accounts.update_user(user, attrs) do
      {:ok, user} ->
        conn
        |> redirect(to: admin_path(conn, :index_all))

      {:error, _changest} ->
        conn
        |> redirect(to: admin_path(conn, :index_all))
    end
  end
end
