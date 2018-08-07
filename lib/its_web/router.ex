defmodule ItsWeb.Router do
  use ItsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ItsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/sign-in", SessionController, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", ItsWeb do
  #   pipe_through :api
  # end
end
