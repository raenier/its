defmodule ItsWeb.PageController do
  use ItsWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
