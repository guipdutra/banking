defmodule BankingWeb.TransactionController do
  use BankingWeb, :controller

  alias Banking.Contexts.{CheckingAccounts, Cashier}
  alias Banking.Schemas.{CheckingAccount, Transaction, User}

  action_fallback BankingWeb.FallbackController

  def create(conn, %{"transaction" => %{"type" => "withdrawal"} = transaction_params}) do
    with %User{} = user <- Guardian.Plug.current_resource(conn),
         %CheckingAccount{} = from_checking_account <-
           CheckingAccounts.get_checking_account_by_user_and_number(
             user.id,
             transaction_params["from_checking_account_number"]
           ),
         {:ok, %Transaction{} = transaction} <-
           Cashier.create_transaction(transaction_params, from_checking_account) do
      render_show(conn, transaction)
    end
  end

  def create(conn, %{"transaction" => %{"type" => "transfer"} = transaction_params}) do
    with %User{} = user <- Guardian.Plug.current_resource(conn),
         %CheckingAccount{} = from_checking_account <-
           CheckingAccounts.get_checking_account_by_user_and_number(
             user.id,
             transaction_params["from_checking_account_number"]
           ),
         {:ok, %Transaction{} = transaction} <-
           Cashier.create_transaction(transaction_params, from_checking_account) do
      render_show(conn, transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Cashier.get_transaction!(id)
    render(conn, "show.json", transaction: transaction)
  end

  defp render_show(conn, transaction) do
    conn
    |> put_status(:created)
    |> put_resp_header("location", Routes.transaction_path(conn, :show, transaction))
    |> render("show.json", transaction: transaction)
  end
end
