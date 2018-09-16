defmodule ItsWeb.SessionController do
  use ItsWeb, :controller

  alias Its.Accounts
  alias Its.Accounts.User

  def new(conn, _params) do
    admin_count =
      ["admin"]
      |> Accounts.list_users_only
      |> Enum.count()

    conn = put_layout conn, false
    unless admin_count == 0 do
      if ItsWeb.Helpers.Auth.signed_in?(conn) do
        conn
        |>redirect(to: page_path(conn, :index))
      else
        render conn, "new.html"
      end
    else
        changeset = User.changeset(%Accounts.User{}, %{})
        render conn, "sign_up.html", changeset: changeset
    end
  end

  def create(conn, %{"session" => auth_params}) do
    user = Accounts.get_user_by_username(auth_params["username"])
    if is_nil(user) do
      conn
      |> put_layout(false)
      |> put_flash(:error, "Invalid username/password")
      |> render("new.html")
    else
      if auth_params["password"] == user.password do
        #if match redirect to corresponding page based on its type
        #set ol_status to 1
        Accounts.update_user(user, %{ol_status: 1})
        conn
        |> put_session(:current_user_id, user.id)
        |> redirect(to: page_path(conn, :index))
      else
        conn
        |> put_layout(false)
        |> put_flash(:error, "Invalid username/password")
        |> render("new.html")
      end
    end
  end

  def sign_up(conn, %{"user" => attrs}) do
    case Accounts.create_user(attrs) do
      {:ok, user} ->
        conn
        |> redirect(to: session_path(conn, :new))
      {:error, changeset} ->
        conn
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, params) do
    #set user ol_status to 0-offline
    conn
    |> get_session(:current_user_id)
    |> Accounts.get_user!()
    |> Accounts.update_user(%{ol_status: 0})

    conn
    |> delete_session(:current_user_id)
    |> redirect(to: page_path(conn, :index))
  end
end
