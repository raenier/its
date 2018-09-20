defmodule ItsWeb.AdminController do
  use ItsWeb, :controller
  require Ecto.Query

  alias Ecto.Query
  alias Its.Accounts
  alias Its.Devices
  alias Its.Devices.Computer
  alias Its.Issue
  alias Its.Issue.Ticket
  alias Its.Issue.Task

  plug :check_admin_auth

  defp check_admin_auth(conn, _args) do
    if user_id = get_session(conn, :current_user_id) do
      current_user = Accounts.get_user!(user_id)
      case current_user.type do
        "admin" ->
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

  def index_all(conn, _params) do
    users = Accounts.list_users_only(["client", "technician", "headtech"])
    changeset = Accounts.change_user(%Accounts.User{})
    active_tab = 1
    render conn, "index.html", users: users, changeset: changeset, active_tab: active_tab
  end

  def index_clients(conn, _params) do
    users = Accounts.list_users_only(["client"])
    changeset = Accounts.change_user(%Accounts.User{})
    active_tab = 2
    render conn, "index.html", users: users, changeset: changeset, active_tab: active_tab
  end

  def index_tech(conn, _params) do
    users = Accounts.list_users_only(["technician", "headtech"])
    changeset = Accounts.change_user(%Accounts.User{})
    active_tab = 3
    render conn, "index.html", users: users, changeset: changeset, active_tab: active_tab
  end

  def devices(conn, params) do
    computers = Its.Devices.list_computers()
    changeset = Its.Devices.Computer.changeset(%Computer{}, %{})
    clients = Accounts.map_name_id(["client"])
    render conn, "devices.html", computers: computers, changeset: changeset, clients: clients
  end

  def create_device(conn, %{"computer" => attrs}) do
    case Devices.create_computer(attrs) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Device succesfully added")
        |> redirect(to: admin_path(conn, :devices))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Input invalid/error")
        |> redirect(to: admin_path(conn, :devices))
    end
  end

  def update_device(conn, %{"id" => id, "computer" => attrs}) do
    computer = Devices.get_computer! id
    case Devices.update_computer(computer, attrs) do
      {:ok, device} ->
        conn
        |> put_flash(:info, "Successful update")
        |> redirect(to: admin_path(conn, :devices))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error on update of device please check inputs")
        |> redirect(to: admin_path(conn, :devices))
    end
  end

  def delete_device(conn, %{"id" => id}) do
    device = Devices.get_computer!(id)
    case Devices.delete_computer(device) do
      {:ok, _device} ->
        conn
        |> put_flash(:info, "Deleted")
        |> redirect(to: admin_path(conn, :devices))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Error on delete of device")
        |> redirect(to: admin_path(conn, :devices))
    end
  end

  def create(conn, %{"user" => attrs}) do
    case Accounts.create_user(attrs) do
      {:ok, user} ->
        conn
        |> redirect(to: admin_path(conn, :index_all))
      {:error, changeset} ->
        conn
        |> redirect(to: admin_path(conn, :index_all))
    end
  end

  def delete(conn, %{ "id" => id ,"tab" => active_tab}) do
    user = Accounts.get_user! id
    case Accounts.delete_user(user) do
      {:ok, user} ->
        case active_tab do
          "1" ->
            conn
            |> redirect(to: admin_path(conn, :index_all))

          "2" ->
            conn
            |> redirect(to: admin_path(conn, :index_clients))

          "3" ->
            conn
            |> redirect(to: admin_path(conn, :index_tech))
        end
    end
  end

  def update(conn, %{"id" => id, "user" => attrs}) do
    user = Accounts.get_user! id
    case Accounts.update_user(user, attrs) do
      {:ok, user} ->
        conn
        |> redirect(to: admin_path(conn, :index_all))

      {:error, _changest} ->
        conn
        |> redirect(to: admin_path(conn, :index_all))
    end
  end

  def tickets(conn, params) do
    tickets =
      Ticket
      |> Query.where([t], t.status !=4)
      |> Its.Repo.paginate(params)

    active_tab = 1
    name_and_id = Accounts.map_name_id(["admin", "technician"])
    render conn, "tickets.html", tickets: tickets, active_tab: active_tab, name_and_id: name_and_id
  end

  def assign(conn, %{"id" => id, "ticket" => attrs}) do
    user_id = get_session(conn, :current_user_id)
    ticket = Issue.get_ticket! id
    case Issue.assign_tech_and_update_status(ticket, attrs) do
      {:ok, ticket} ->
        conn
        |> redirect(to: admin_path(conn, :tickets))

      {:error, Changeset} ->
        conn
        |> redirect(to: admin_path(conn, :tickets))
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
        redirect(conn, to: admin_path(conn, :show, ticket_id))

      {:error, changeset} ->
        redirect(conn, to: admin_path(conn, :show, ticket_id))

    end
  end

  def update_task(conn, %{"ticketid" => ticket_id, "taskid" => task_id, "task" => attrs}) do
    task = Issue.get_task! task_id
    user_id = get_session(conn, :current_user_id)

    if user_id == task.user_id do
      case Issue.update_task(task, attrs) do
        {:ok, task} ->
          redirect(conn, to: admin_path(conn, :show, ticket_id))

        {:error, changeset} ->
          conn
          |> put_flash(:error, "Error Updating Task")
          |> redirect(to: admin_path(conn, :show, ticket_id))
      end
    else
        conn
        |> put_flash(:error, "Error Updating Task")
        |> redirect(to: admin_path(conn, :show, ticket_id))
    end
  end

  def delete_task(conn, %{"ticketid" => ticket_id, "taskid" => task_id}) do
    task = Issue.get_task! task_id
    user_id = get_session(conn, :current_user_id)

    if user_id == task.user_id do
      case Issue.delete_task task do
        {:ok, task} ->
          redirect(conn, to: admin_path(conn, :show, ticket_id))

        _ ->
          redirect(conn, to: admin_path(conn, :show, ticket_id))
      end
    else
      redirect(conn, to: admin_path(conn, :show, ticket_id))
    end
  end

  def update_ticket(conn, %{"id" => id, "ticket" => attrs}) do
    ticket = Issue.get_ticket! id
    attrs =
    if attrs["progress"] == "100" do
      Map.put attrs, "status", 3
    else
      Map.put attrs, "status", 2
    end

    case Issue.update_ticket(ticket, attrs) do
      {:ok, ticket} ->
        redirect(conn, to: admin_path(conn, :show, ticket))


      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error on updating ticket")
        |> redirect(to: admin_path(conn, :show, ticket))
    end
  end

  def ticket_delete(conn, %{"id" => id}) do
    ticket = Issue.get_ticket! id
    case Issue.delete_ticket ticket do
      {:ok, _ticket} ->
        redirect(conn, to: admin_path(conn, :tickets))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Error Deleting Ticket")
        |> redirect(to: admin_path(conn, :tickets))
    end
  end

  def tickets_pending(conn, params) do
    tickets =
      Ticket
      |> Query.where([t], t.status !=4 and t.status == 1)
      |> Its.Repo.paginate(params)

    pending_count = Enum.count tickets
    active_tab = 2
    name_and_id = Accounts.map_name_id(["admin", "technician"])
    render(conn, "tickets.html", tickets: tickets, name_and_id: name_and_id, active_tab: active_tab, notif: pending_count)
  end

  def tasks(conn, params) do
    user_id = get_session(conn, :current_user_id)
    tickets =
      Ticket
      |> Query.where([t], t.tech_id == ^user_id)
      |> Its.Repo.paginate(params)

    active_tab = 3
    name_and_id = Accounts.map_name_id(["admin", "technician"])
    render(conn, "tickets.html", tickets: tickets, name_and_id: name_and_id, active_tab: active_tab)
  end

  def to_others(conn, params) do
    user_id = get_session(conn, :current_user_id)
    tickets =
      Ticket
      |> Query.where([t], t.tech_id != ^user_id)
      |> Its.Repo.paginate(params)

    active_tab = 4
    name_and_id = Accounts.map_name_id(["admin", "technician"])
    render(conn, "tickets.html", tickets: tickets, name_and_id: name_and_id, active_tab: active_tab)
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

  def show_ticket(conn, %{"ticketid" => ticket_id}) do
    ticket =
      ticket_id
      |> Issue.get_ticket!
      |> Its.Repo.preload([:client, :tech, :htech, :computer, tasks: [:user]])

    conn
    |> render("show_ticket.html", ticket: ticket)
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
        redirect(conn, to: admin_path(conn, :profile_setting))

      {:ok, changeset} ->
        redirect(conn, to: admin_path(conn, :profile_setting))
    end
  end
end
