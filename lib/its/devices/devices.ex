defmodule Its.Devices do
  @moduledoc """
  The Devices context.
  """

  import Ecto.Query, warn: false
  alias Its.Repo

  alias Its.Devices.Computer

  @doc """
  Returns the list of computers.

  ## Examples

      iex> list_computers()
      [%Computer{}, ...]

  """
  def list_computers do
    Repo.all(Computer)
  end

  @doc """
  Gets a single computer.

  Raises `Ecto.NoResultsError` if the Computer does not exist.

  ## Examples

      iex> get_computer!(123)
      %Computer{}

      iex> get_computer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_computer!(id), do: Repo.get!(Computer, id)

  @doc """
  Creates a computer.

  ## Examples

      iex> create_computer(%{field: value})
      {:ok, %Computer{}}

      iex> create_computer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_computer(attrs \\ %{}) do
    %Computer{}
    |> Computer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a computer.

  ## Examples

      iex> update_computer(computer, %{field: new_value})
      {:ok, %Computer{}}

      iex> update_computer(computer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_computer(%Computer{} = computer, attrs) do
    computer
    |> Computer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Computer.

  ## Examples

      iex> delete_computer(computer)
      {:ok, %Computer{}}

      iex> delete_computer(computer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_computer(%Computer{} = computer) do
    Repo.delete(computer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking computer changes.

  ## Examples

      iex> change_computer(computer)
      %Ecto.Changeset{source: %Computer{}}

  """
  def change_computer(%Computer{} = computer) do
    Computer.changeset(computer, %{})
  end
end
