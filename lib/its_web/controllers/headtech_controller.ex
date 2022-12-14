defmodule ItsWeb.HeadtechController  do
  use ItsWeb, :controller
  require Ecto.Query

  alias Ecto.Query
  alias Its.Issue
  alias Its.Issue.Ticket
  alias Its.Issue.Task
  alias Its.Accounts

  plug :check_headtech_auth

  defp check_headtech_auth(conn, _args) do
    if user_id = get_session(conn, :current_user_id) do
      current_user = Accounts.get_user!(user_id)
      case current_user.type do
        "headtech" ->
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
    tickets =
      Ticket
      |> Query.where([t], t.status !=4 and t.status == 1)
      |> Its.Repo.paginate(params)

    pending_count = Enum.count tickets
    active_tab = 1
    name_and_id = Accounts.map_name_id(["headtech", "technician"])
    render(conn, "index.html", tickets: tickets, name_and_id: name_and_id, active_tab: active_tab, notif: pending_count)
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
    attrs =
    if attrs["progress"] == "100" do
      Map.put attrs, "status", 3
    else
      Map.put attrs, "status", 2
    end

    case Issue.update_ticket(ticket, attrs) do
      {:ok, ticket} ->
        redirect(conn, to: headtech_path(conn, :show, ticket))


      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error on updating ticket")
        |> redirect(to: headtech_path(conn, :show, ticket))
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
        redirect(conn, to: headtech_path(conn, :show, ticket_id))

      {:error, changeset} ->
        redirect(conn, to: headtech_path(conn, :show, ticket_id))

    end
  end

  #TODO can only update task that belongs to you
  def update_task(conn, %{"ticketid" => ticket_id, "taskid" => task_id, "task" => attrs}) do
    task = Issue.get_task! task_id
    user_id = get_session(conn, :current_user_id)

    if user_id == task.user_id do
      case Issue.update_task(task, attrs) do
        {:ok, task} ->
          redirect(conn, to: headtech_path(conn, :show, ticket_id))

        {:error, changeset} ->
          conn
          |> put_flash(:error, "Error Updating Task")
          |> redirect(to: headtech_path(conn, :show, ticket_id))
      end
    else
        conn
        |> put_flash(:error, "Error Updating Task")
        |> redirect(to: headtech_path(conn, :show, ticket_id))
    end
  end

  #TODO can only delete task that belongs to you
  def delete_task(conn, %{"ticketid" => ticket_id, "taskid" => task_id}) do
    task = Issue.get_task! task_id
    user_id = get_session(conn, :current_user_id)

    if user_id == task.user_id do
      case Issue.delete_task task do
        {:ok, task} ->
          redirect(conn, to: headtech_path(conn, :show, ticket_id))

        _ ->
          redirect(conn, to: headtech_path(conn, :show, ticket_id))
      end
    else
      redirect(conn, to: headtech_path(conn, :show, ticket_id))
    end
  end

  def assign(conn, %{"id" => id, "ticket" => attrs}) do
    user_id = get_session(conn, :current_user_id)
    #also put htech_id to know who assigned the ticket
    attrs = Map.put(attrs, "htech_id", user_id)

    ticket = Issue.get_ticket! id
    case Issue.assign_tech_and_update_status(ticket, attrs) do
      {:ok, ticket} ->
        conn
        |> redirect(to: headtech_path(conn, :index))

      {:error, Changeset} ->
        conn
        |> redirect(to: headtech_path(conn, :index))
    end
  end

  def tasks(conn, params) do
    user_id = get_session(conn, :current_user_id)
    tickets =
      Ticket
      |> Query.where([t], t.tech_id == ^user_id)
      |> Its.Repo.paginate(params)

    active_tab = 2
    name_and_id = Accounts.map_name_id(["headtech", "technician"])
    render(conn, "index.html", tickets: tickets, name_and_id: name_and_id, active_tab: active_tab)
  end

  def to_others(conn, params) do
    user_id = get_session(conn, :current_user_id)
    tickets =
      Ticket
      |> Query.where([t], t.htech_id == ^user_id and (t.tech_id != ^user_id or is_nil(t.tech_id)))
      |> Its.Repo.paginate(params)

    active_tab = 3
    name_and_id = Accounts.map_name_id(["headtech", "technician"])
    render(conn, "index.html", tickets: tickets, name_and_id: name_and_id, active_tab: active_tab)
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
        redirect(conn, to: headtech_path(conn, :profile_setting))

      {:ok, changeset} ->
        redirect(conn, to: headtech_path(conn, :profile_setting))
    end
  end
end
