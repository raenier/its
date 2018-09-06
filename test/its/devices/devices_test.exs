defmodule Its.DevicesTest do
  use Its.DataCase

  alias Its.Devices

  describe "computers" do
    alias Its.Devices.Computer

    @valid_attrs %{graphics: "some graphics", model: "some model", os: "some os", processor: "some processor", ram: "some ram", softwares: %{}}
    @update_attrs %{graphics: "some updated graphics", model: "some updated model", os: "some updated os", processor: "some updated processor", ram: "some updated ram", softwares: %{}}
    @invalid_attrs %{graphics: nil, model: nil, os: nil, processor: nil, ram: nil, softwares: nil}

    def computer_fixture(attrs \\ %{}) do
      {:ok, computer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Devices.create_computer()

      computer
    end

    test "list_computers/0 returns all computers" do
      computer = computer_fixture()
      assert Devices.list_computers() == [computer]
    end

    test "get_computer!/1 returns the computer with given id" do
      computer = computer_fixture()
      assert Devices.get_computer!(computer.id) == computer
    end

    test "create_computer/1 with valid data creates a computer" do
      assert {:ok, %Computer{} = computer} = Devices.create_computer(@valid_attrs)
      assert computer.graphics == "some graphics"
      assert computer.model == "some model"
      assert computer.os == "some os"
      assert computer.processor == "some processor"
      assert computer.ram == "some ram"
      assert computer.softwares == %{}
    end

    test "create_computer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Devices.create_computer(@invalid_attrs)
    end

    test "update_computer/2 with valid data updates the computer" do
      computer = computer_fixture()
      assert {:ok, computer} = Devices.update_computer(computer, @update_attrs)
      assert %Computer{} = computer
      assert computer.graphics == "some updated graphics"
      assert computer.model == "some updated model"
      assert computer.os == "some updated os"
      assert computer.processor == "some updated processor"
      assert computer.ram == "some updated ram"
      assert computer.softwares == %{}
    end

    test "update_computer/2 with invalid data returns error changeset" do
      computer = computer_fixture()
      assert {:error, %Ecto.Changeset{}} = Devices.update_computer(computer, @invalid_attrs)
      assert computer == Devices.get_computer!(computer.id)
    end

    test "delete_computer/1 deletes the computer" do
      computer = computer_fixture()
      assert {:ok, %Computer{}} = Devices.delete_computer(computer)
      assert_raise Ecto.NoResultsError, fn -> Devices.get_computer!(computer.id) end
    end

    test "change_computer/1 returns a computer changeset" do
      computer = computer_fixture()
      assert %Ecto.Changeset{} = Devices.change_computer(computer)
    end
  end
end
