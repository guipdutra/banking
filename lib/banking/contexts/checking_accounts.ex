defmodule Banking.Contexts.CheckingAccounts do
  @moduledoc """
  The CheckingAccounts context.
  """

  import Ecto.Query, warn: false
  alias Banking.Repo

  alias Banking.Schemas.User
  alias Banking.Schemas.CheckingAccount

  @doc """
  Returns a unique checking account number.
  ## Examples
      iex> generate_number()
      "1234567890"
  """
  def generate_number do
    lenght = 26
    number = :crypto.strong_rand_bytes(lenght) |> Base.url_encode64 |> binary_part(0, lenght)

    case list_checking_accounts_by_number(number) do
      [] -> number
      _ -> generate_number()
    end
  end

  @doc """
  Returns the list of checking_accounts.
  ## Examples
      iex> list_checking_accounts()
      [%CheckingAccount{}, ...]
  """
  def list_checking_accounts do
    Repo.all(CheckingAccount)
  end

  @doc """
  Gets a single checking_account.
  Raises `Ecto.NoResultsError` if the Checking account does not exist.
  ## Examples
      iex> get_checking_account!(123)
      %CheckingAccount{}
      iex> get_checking_account!(456)
      ** (Ecto.NoResultsError)
  """
  def get_checking_account!(id), do: Repo.get!(CheckingAccount, id)

  @doc """
  Gets a single checking_account by number.
  Returns not_found if number is invalid.
  ## Examples
      iex> get_checking_account_by_number(1234567890)
      %CheckingAccount{}
      iex> get_checking_account_by_number(456)
      ** {:error, :not_found}
  """
  def get_checking_account_by_number(number) do
    case checking_account = Repo.get_by(CheckingAccount, number: number) do
      %CheckingAccount{} -> checking_account
      _ -> {:error, :not_found}
    end
  end

  @doc """
  Gets a single checking_account by number and user id.
  Returns not_found if number or user is invalid.
  ## Examples
      iex> get_checking_account_by_user_and_number(1, 1234567890)
      %CheckingAccount{}
      iex> get_checking_account_by_user_and_number(0, 1234567890)
      ** {:error, :not_found}
  """
  def get_checking_account_by_user_and_number(user_id, number) do
    query =
      from user in User,
        join: checking_account in assoc(user, :checking_account),
        where: checking_account.number == ^number,
        where: user.id == ^user_id,
        select: checking_account

    case checking_account = Repo.one(query) do
      %CheckingAccount{} -> checking_account
      _ -> {:error, :not_found}
    end
  end

  @doc """
  Updates a checking_account.
  ## Examples
      iex> update_checking_account(checking_account, %{field: new_value})
      {:ok, %CheckingAccount{}}
      iex> update_checking_account(checking_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_checking_account(%CheckingAccount{} = checking_account, attrs) do
    checking_account
    |> CheckingAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Validate if checking account as a balance for a executing transaction.
  ## Examples
      iex> validate_balance(checking_account, 1000)
      true
      iex> validate_balance(checking_account, 100_000_000)
      false
  """
  def validate_balance(%CheckingAccount{} = checking_account, value) do
    checking_account.balance > value
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking checking_account changes.
  ## Examples
      iex> change_checking_account(checking_account)
      %Ecto.Changeset{source: %CheckingAccount{}}
  """
  def change_checking_account(%CheckingAccount{} = checking_account) do
    CheckingAccount.changeset(checking_account, %{})
  end

  defp list_checking_accounts_by_number(number) do
    query =
      from ca in CheckingAccount,
        where: ca.number == ^number

    Repo.all(query)
  end
end
