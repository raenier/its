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
    post "/sign-in", SessionController, :create
    delete "/sign-in", SessionController, :delete
    post "/sign-up", SessionController, :sign_up
  end

  scope "/admin", ItsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", AdminController, :index_all
    get "/clients", AdminController, :index_clients
    get "/techs", AdminController, :index_tech
    post "/", AdminController, :create
    delete "/:id/:tab", AdminController, :delete
    put "/:id", AdminController, :update
    get "/devices", AdminController, :devices
    post "/devices", AdminController, :create_device
  end

  scope "/client", ItsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", ClientController, :index
    post "/", ClientController, :create
    get "/active", ClientController, :active
    get "/pending", ClientController, :pending
    get "/discarded", ClientController, :discarded
    get "/done", ClientController, :done
    put "/:id", ClientController, :update
    put "ticket/:id", ClientController, :update_ticket_status
    delete "/:id", ClientController, :delete
  end

  scope "/headtech", ItsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", HeadtechController, :index
    get "/tasks", HeadtechController, :tasks
    get "/assigned", HeadtechController, :to_others
    put "/ticket/:id", HeadtechController, :assign
  end
  # Other scopes may use custom stacks.
  # scope "/api", ItsWeb do
  #   pipe_through :api
  # end
end
