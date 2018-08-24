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
end
