defmodule Its.IssueTest do
  use Its.DataCase

  alias Its.Issue

  describe "tickets" do
    alias Its.Issue.Ticket

    @valid_attrs %{category: "some category", priority: 42, status: 42, title: "some title"}
    @update_attrs %{category: "some updated category", priority: 43, status: 43, title: "some updated title"}
    @invalid_attrs %{category: nil, priority: nil, status: nil, title: nil}

    def ticket_fixture(attrs \\ %{}) do
      {:ok, ticket} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Issue.create_ticket()

      ticket
    end

    test "list_tickets/0 returns all tickets" do
      ticket = ticket_fixture()
      assert Issue.list_tickets() == [ticket]
    end

    test "get_ticket!/1 returns the ticket with given id" do
      ticket = ticket_fixture()
      assert Issue.get_ticket!(ticket.id) == ticket
    end

    test "create_ticket/1 with valid data creates a ticket" do
      assert {:ok, %Ticket{} = ticket} = Issue.create_ticket(@valid_attrs)
      assert ticket.category == "some category"
      assert ticket.priority == 42
      assert ticket.status == 42
      assert ticket.title == "some title"
    end

    test "create_ticket/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Issue.create_ticket(@invalid_attrs)
    end

    test "update_ticket/2 with valid data updates the ticket" do
      ticket = ticket_fixture()
      assert {:ok, ticket} = Issue.update_ticket(ticket, @update_attrs)
      assert %Ticket{} = ticket
      assert ticket.category == "some updated category"
      assert ticket.priority == 43
      assert ticket.status == 43
      assert ticket.title == "some updated title"
    end

    test "update_ticket/2 with invalid data returns error changeset" do
      ticket = ticket_fixture()
      assert {:error, %Ecto.Changeset{}} = Issue.update_ticket(ticket, @invalid_attrs)
      assert ticket == Issue.get_ticket!(ticket.id)
    end

    test "delete_ticket/1 deletes the ticket" do
      ticket = ticket_fixture()
      assert {:ok, %Ticket{}} = Issue.delete_ticket(ticket)
      assert_raise Ecto.NoResultsError, fn -> Issue.get_ticket!(ticket.id) end
    end

    test "change_ticket/1 returns a ticket changeset" do
      ticket = ticket_fixture()
      assert %Ecto.Changeset{} = Issue.change_ticket(ticket)
    end
  end

  describe "tasks" do
    alias Its.Issue.Task

    @valid_attrs %{description: "some description"}
    @update_attrs %{description: "some updated description"}
    @invalid_attrs %{description: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Issue.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Issue.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Issue.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Issue.create_task(@valid_attrs)
      assert task.description == "some description"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Issue.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, task} = Issue.update_task(task, @update_attrs)
      assert %Task{} = task
      assert task.description == "some updated description"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Issue.update_task(task, @invalid_attrs)
      assert task == Issue.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Issue.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Issue.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Issue.change_task(task)
    end
  end
end
