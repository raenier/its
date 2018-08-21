defmodule ItsWeb.Helpers.Auth do

  def signed_in?(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    if user_id, do: !!Its.Repo.get(Its.Accounts.User, user_id)
  end

  #use after using signed_in?/1
  def check_user_type(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    user = Its.Accounts.get_user!(user_id)
    user.type
  end
end
