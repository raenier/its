defmodule ItsWeb.TechController do
  use ItsWeb, :controller
  require Ecto.Query

  alias Ecto.Query
  alias Its.Issue
  alias Its.Issue.Ticket
  alias Its.Issue.Task
  alias Its.Accounts

  plug :check_tech_auth

  defp check_tech_auth(conn, _args) do
    if user_id = get_session(conn, :current_user_id) do
      current_user = Accounts.get_user!(user_id)
      case current_user.type do
        "technician" ->
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
      |> Query.where([t], t.tech_id == ^user_id and t.status == 2)
      |> Its.Repo.paginate(params)

    active_tab = 1
    render(conn, "index.html", tickets: tickets, active_tab: active_tab)
  end

  def search_ticket(conn, params) do
    %{"search" => %{"input" => userinput, "attr" => attr}} = params
    tickets = Issue.search_tech_tickets(userinput, attr, params)
    active_tab = 1
    render(conn, "index.html", tickets: tickets, active_tab: active_tab)
  end

  def done(conn, params) do
    user_id = get_session(conn, :current_user_id)
    tickets =
      Ticket
      |> Query.where([t], t.tech_id == ^user_id and t.status == 3)
      |> Its.Repo.paginate(params)

    active_tab = 2
    render(conn, "index.html", tickets: tickets, active_tab: active_tab)
  end

  def show(conn, %{"id" => id}) do
    ticket =
      id
      |> Issue.get_ticket!
      |> Its.Repo.preload([:client, :tech, :htech, :computer, tasks: [:user]])
    user_id = get_session(conn, :current_user_id)

    changeset = Issue.change_ticket(ticket)
    changeset_task = Task.changeset(%Task{}, %{})

    render conn, "show.html", ticket: ticket, current_user_id: user_id, changeset_task: changeset_task, changeset: changeset
  end

  def update(conn, %{"id" => id, "ticket" => attrs}) do
    ticket = Issue.get_ticket! id

    case Issue.update_ticket(ticket, attrs) do
      {:ok, ticket} ->
        redirect(conn, to: tech_path(conn, :show, ticket))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error on updating ticket")
        |> redirect(to: tech_path(conn, :show, ticket))
    end
  end

  def create_task(conn, %{"id" => ticket_id, "task" => attrs}) do
    user_id = get_session(conn, :current_user_id)
    attrs =
      attrs
      |> Map.put("ticket_id", ticket_id)
      |> Map.put("user_id", user_id)

    case Issue.create_task(attrs) do
      {:ok, task} ->
        redirect(conn, to: tech_path(conn, :show, ticket_id))

      {:error, changeset} ->
        redirect(conn, to: tech_path(conn, :show, ticket_id))

    end
  end

  def update_task(conn, %{"ticketid" => ticket_id, "taskid" => task_id, "task" => attrs}) do
    task = Issue.get_task! task_id
    user_id = get_session(conn, :current_user_id)

    if user_id == task.user_id do
      case Issue.update_task(task, attrs) do
        {:ok, task} ->
          redirect(conn, to: tech_path(conn, :show, ticket_id))

        {:error, changeset} ->
          conn
          |> put_flash(:error, "Error Updating Task")
          |> redirect(to: tech_path(conn, :show, ticket_id))
      end
    else
        conn
        |> put_flash(:error, "Error Updating Task")
        |> redirect(to: tech_path(conn, :show, ticket_id))
    end
  end

  def delete_task(conn, %{"ticketid" => ticket_id, "taskid" => task_id}) do
    task = Issue.get_task! task_id
    user_id = get_session(conn, :current_user_id)

    if user_id == task.user_id do
      case Issue.delete_task task do
        {:ok, task} ->
          redirect(conn, to: tech_path(conn, :show, ticket_id))

        _ ->
          redirect(conn, to: tech_path(conn, :show, ticket_id))
      end
    else
      redirect(conn, to: tech_path(conn, :show, ticket_id))
    end
  end

  def profile_setting(conn, _params) do
    user =
      conn
      |> get_session(:current_user_id)
      |> Accounts.get_user!()

    changeset = Accounts.change_user(user)
    conn
    |> render("profile.html", user: user, changeset: changeset)
  end

  def update_profile(conn, %{"id" => id, "user" => attrs}) do
    user = Accounts.get_user! id
    case Accounts.update_user(user, attrs) do
      {:ok, user} ->
        redirect(conn, to: tech_path(conn, :profile_setting))

      {:ok, changeset} ->
        redirect(conn, to: tech_path(conn, :profile_setting))
    end
  end
end
