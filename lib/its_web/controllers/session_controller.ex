defmodule ItsWeb.SessionController do
  use ItsWeb, :controller

  alias Its.Accounts

  def new(conn, _params) do
    conn = put_layout conn, false
    if ItsWeb.Helpers.Auth.signed_in?(conn) do
      #redirect according to user type
      conn
      |>redirect(to: page_path(conn, :index))
    else
      render conn, "new.html"
    end
  end

  def create(conn, %{"session" => auth_params}) do
    user = Accounts.get_user_by_username(auth_params["username"])
    if is_nil(user) do
      conn = put_layout conn, false
      render(conn, "new.html")
    else
      if auth_params["password"] == user.password do
        #if match redirect to corresponding page based on its type
        conn
        |> put_session(:current_user_id, user.id)
        |> redirect(to: page_path(conn, :index))
      else
        conn
        |> put_layout(false)
        |> render("new.html")
      end
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_layout(false)
    |> render("new.html")
  end
end
