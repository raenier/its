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
    get "/tickets", AdminController, :tickets
    delete "/tickets/:id/delete", AdminController, :ticket_delete
    get "/ticket/:ticketid", AdminController, :show_ticket
  end

  scope "/admin/profile", ItsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", AdminController, :profile_setting
    put "/:id", AdminController, :update_profile
  end

  scope "/admin/devices", ItsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", AdminController, :devices
    post "/", AdminController, :create_device
    put "/:id", AdminController, :update_device
    delete "/delete/:id", AdminController, :delete_device
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
    get "/show/:id", ClientController, :show
  end

  scope "/headtech", ItsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", HeadtechController, :index
    get "/tasks", HeadtechController, :tasks
    get "/assigned", HeadtechController, :to_others
    put "/ticket/:id/tech", HeadtechController, :assign
    get "/ticket/:id", HeadtechController, :show
    put "/ticket/:id", HeadtechController, :update
    post "/ticket/:id/task", HeadtechController, :create_task
    put "/ticket/:ticketid/task/:taskid", HeadtechController, :update_task
    delete "/ticket/:ticketid/task/:taskid", HeadtechController, :delete_task
  end

  scope "/tech", ItsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", TechController, :index
    get "/done", TechController, :done
    get "/ticket/:id", TechController, :show
    put "/ticket/:id", TechController, :update
    post "/ticket/:id", TechController, :create_task
    put "/ticket/:ticketid/task/:taskid", TechController, :update_task
    delete "/ticket/:ticketid/task/:taskid", TechController, :delete_task
  end

  # Other scopes may use custom stacks.
  # scope "/api", ItsWeb do
  #   pipe_through :api
  # end
end
