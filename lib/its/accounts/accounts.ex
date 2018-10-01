defmodule Its.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Query
  alias Its.Repo

  alias Its.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def list_users_only(criteria) do
    query = from u in User, where: u.type in ^criteria
    Repo.all(query)
  end

  def list_online_users(type) do
    from(u in User, where: u.ol_status == 1 and u.type in ^type)
    |> Repo.all
  end

  def search_user(userinput, attr) do
    userinput
    |> gen_query(attr)
    |> Repo.all()
  end

  def gen_query(userinput, attr) do
    querystr = "%#{userinput}%"
    type = ["client", "technician"]

    case attr do
      "first_name" ->
        Query.from(u in User, where: u.type in ^type and ilike(u.first_name, ^querystr))

      "middle_name" ->
        Query.from(u in User, where: u.type in ^type and ilike(u.middle_name, ^querystr))

      "last_name" ->
        Query.from(u in User, where: u.type in ^type and ilike(u.last_name, ^querystr))

      "username" ->
        Query.from(u in User, where: u.type in ^type and ilike(u.username, ^querystr))
    end
  end

  def map_name_id(usertypes) do
    list_users_only(usertypes)
    |> Enum.map(fn user -> {:"#{user.first_name <> " " <> user.last_name}", user.id} end)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets single user by username attribute

  """
  def get_user_by_username(username) when is_nil(username) do
    nil
  end
  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
