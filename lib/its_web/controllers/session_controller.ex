defmodule ItsWeb.SessionController do
  use ItsWeb, :controller

  alias Its.Accounts

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => auth_params}) do
    user = Accounts.get_user_by_username(auth_params["username"])
    if is_nil(user) do
      render(conn, "new.html")
    else
      if auth_params["password"] == user.password do
        #if match redirect to corresponding page based on its type
        conn
        |> put_session(:current_user_id, user.id)
        |> redirect(to: page_path(conn, :index))
      else
        render conn, "new.html"
      end
    end
  end
end
