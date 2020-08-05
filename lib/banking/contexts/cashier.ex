defmodule Banking.Contexts.Cashier do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Banking.Repo

  alias Banking.Contexts.CheckingAccounts
  alias Banking.Schemas.CheckingAccount
  alias Banking.Schemas.Transaction

  @doc """
  Gets a single transaction.
  Raises `Ecto.NoResultsError` if the Transaction does not exist.
  ## Examples
      iex> get_transaction!(123)
      %Transaction{}
      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)
  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.
  ## Examples
      iex> create_transaction(%{field: value}, %CheckingAccount{})
      {:ok, %Transaction{}}
      iex> create_transaction(%{field: bad_value}, %CheckingAccount{})
      {:error, %Ecto.Changeset{}}
      iex> create_transaction(%{field: bad_value}, %CheckingAccount{})
      {:error, :insufficient_funds}
  """
  def create_transaction(
        %{"type" => "withdrawal"} = attrs,
        %CheckingAccount{} = from_checking_account
      ) do
    with {:ok, :valid} <- validate_transaction_value(attrs),
         true <- CheckingAccounts.validate_balance(from_checking_account, attrs["value"]),
         {:ok, %CheckingAccount{}} <- decrease_balance(from_checking_account, attrs["value"]) do
      attrs = Map.merge(attrs, %{"from_checking_account_id" => from_checking_account.id})
      do_create_transaction(attrs)
    else
      false -> insufficient_funds_error()
      error -> error
    end
  end

  def create_transaction(
        %{"type" => "transfer"} = attrs,
        %CheckingAccount{} = from_checking_account
      ) do
    with {:ok, :valid} <- validate_transaction_value(attrs),
         true <- CheckingAccounts.validate_balance(from_checking_account, attrs["value"]),
         %CheckingAccount{} = to_checking_account <-
           CheckingAccounts.get_checking_account_by_number(attrs["to_checking_account_number"]),
         {:ok, %CheckingAccount{}} <- decrease_balance(from_checking_account, attrs["value"]),
         {:ok, %CheckingAccount{}} <- increase_balance(to_checking_account, attrs["value"]) do
      attrs =
        Map.merge(attrs, %{
          "to_checking_account_id" => to_checking_account.id,
          "from_checking_account_id" => from_checking_account.id
        })

      do_create_transaction(attrs)
    else
      false ->
        insufficient_funds_error()

      error ->
        error
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.
  ## Examples
      iex> change_transaction(transaction)
      %Ecto.Changeset{source: %Transaction{}}
  """
  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end

  defp insufficient_funds_error do
    {:error, :insufficient_funds}
  end

  defp validate_transaction_value(%{"value" => value}) do
    case value > 0 do
      true -> {:ok, :valid}
      _ -> {:error, :invalid_value}
    end
  end

  defp do_create_transaction(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  defp decrease_balance(acc, value) do
    CheckingAccounts.update_checking_account(acc, %{
      balance: acc.balance - value
    })
  end

  defp increase_balance(acc, value) do
    CheckingAccounts.update_checking_account(acc, %{
      balance: acc.balance + value
    })
  end
end
