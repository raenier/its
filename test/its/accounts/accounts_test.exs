defmodule Its.AccountsTest do
  use Its.DataCase

  alias Its.Accounts

  describe "users" do
    alias Its.Accounts.User

    @valid_attrs %{first_name: "some first_name", last_name: "some last_name", middle_name: "some middle_name", password: "some password", type: "some type", username: "some username"}
    @update_attrs %{first_name: "some updated first_name", last_name: "some updated last_name", middle_name: "some updated middle_name", password: "some updated password", type: "some updated type", username: "some updated username"}
    @invalid_attrs %{first_name: nil, last_name: nil, middle_name: nil, password: nil, type: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.middle_name == "some middle_name"
      assert user.password == "some password"
      assert user.type == "some type"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.middle_name == "some updated middle_name"
      assert user.password == "some updated password"
      assert user.type == "some updated type"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
