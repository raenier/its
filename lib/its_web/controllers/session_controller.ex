defmodule ItsWeb.SessionController do
  use ItsWeb, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end
end
