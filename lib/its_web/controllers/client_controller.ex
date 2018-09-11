defmodule ItsWeb.ClientController do
  use ItsWeb, :controller
  require Ecto.Query

  alias Ecto.Query
  alias Its.Issue
  alias Its.Issue.Ticket
  alias Its.Accounts
  alias Its.Devices

  plug :check_client_auth

  defp check_client_auth(conn, _args) do
    if user_id = get_session(conn, :current_user_id) do
      current_user = Accounts.get_user!(user_id)
      case current_user.type do
        "client" ->
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

  def index(conn, params) do
    user_id = get_session(conn, :current_user_id)
    tickets =
      Ticket
      |> Query.where([t], t.client_id == ^user_id and t.status !=4)
      |> Its.Repo.paginate(params)

    active_tab = 1
    changeset = Issue.change_ticket(%Issue.Ticket{})
    deviceopt = Devices.map_model_id()
    render conn, "index.html",
      tickets: tickets,
      changeset: changeset,
      active_tab: active_tab,
      deviceopt: deviceopt
  end

  def active(conn, params) do
    user_id = get_session(conn, :current_user_id)
    tickets =
      Ticket
      |> Query.where([t], t.client_id == ^user_id and t.status == 2)
      |> Its.Repo.paginate(params)

    active_tab = 2
    changeset = Issue.change_ticket(%Issue.Ticket{})
    deviceopt = Devices.map_model_id()
    render conn, "index.html",
      tickets: tickets,
      changeset: changeset,
      deviceopt: deviceopt,
      active_tab: active_tab
  end

  def pending(conn, params) do
    user_id = get_session(conn, :current_user_id)
    tickets =
      Ticket
      |> Query.where([t], t.client_id == ^user_id and t.status == 1)
      |> Its.Repo.paginate(params)

    active_tab = 3
    changeset = Issue.change_ticket(%Issue.Ticket{})
    deviceopt = Devices.map_model_id()
    render conn, "index.html",
      tickets: tickets,
      changeset: changeset,
      deviceopt: deviceopt,
      active_tab: active_tab
  end

  def discarded(conn, params) do
    user_id = get_session(conn, :current_user_id)
    tickets =
      Ticket
      |> Query.where([t], t.client_id == ^user_id and t.status == 4)
      |> Its.Repo.paginate(params)

    active_tab = 5
    changeset = Issue.change_ticket(%Issue.Ticket{})
    deviceopt = Devices.map_model_id()
    render conn, "index.html",
      tickets: tickets,
      changeset: changeset,
      deviceopt: deviceopt,
      active_tab: active_tab
  end

  def done(conn, params) do
    user_id = get_session(conn, :current_user_id)
    tickets =
      Ticket
      |> Query.where([t], t.client_id == ^user_id and t.status == 3)
      |> Its.Repo.paginate(params)

    active_tab = 4
    changeset = Issue.change_ticket(%Issue.Ticket{})
    deviceopt = Devices.map_model_id()
    render conn, "index.html",
      tickets: tickets,
      changeset: changeset,
      deviceopt: deviceopt,
      active_tab: active_tab
  end

  def create(conn, %{"ticket" => ticket}) do
    client_id = get_session(conn, :current_user_id)
    ticket =
    Map.put(ticket, "client_id", client_id)

    case Issue.create_ticket(ticket) do
      {:ok, ticket} ->
        conn
        |> redirect(to: client_path(conn, :index))
      {:error, changeset} ->
        conn
        |> redirect(to: client_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "ticket" => attrs}) do
    ticket = Issue.get_ticket! id
    case Issue.update_ticket(ticket, attrs) do
      {:ok, ticket} ->
        conn
        |> redirect(to: client_path(conn, :index))

      {:error, Changeset} ->
        conn
        |> redirect(to: client_path(conn, :index))
    end
  end

  def update_ticket_status(conn, %{"id" => id, "ticket" => attrs}) do
    ticket = Issue.get_ticket! id
    case Issue.update_ticket(ticket, attrs) do
      {:ok, ticket} ->
        conn
        |> redirect(to: client_path(conn, :index))

      {:error, Changeset} ->
        conn
        |> redirect(to: client_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    ticket = Issue.get_ticket! id
    Issue.delete_ticket(ticket)

    redirect(conn, to: client_path(conn, :index))
  end

  def show(conn, %{"id" => id}) do
    ticket =
      id
      |> Issue.get_ticket!
      |> Its.Repo.preload([:client, :tech, :htech, :computer, tasks: [:user]])

    render conn, "show.html", ticket: ticket
  end
end
