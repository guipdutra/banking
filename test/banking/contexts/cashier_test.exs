defmodule Banking.CashierTest do
  use Banking.DataCase
  import Banking.Factory

  alias Banking.Contexts.Cashier
  alias Banking.Schemas.Transaction

  describe "transactions" do
    test "get_transaction!/1 returns the transaction with given id" do
      transaction = insert(:withdrawal)
      assert return_transaction = Cashier.get_transaction!(transaction.id)

      assert return_transaction.id == transaction.id
      assert return_transaction.value == transaction.value
      assert return_transaction.type == transaction.type
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = build(:withdrawal)
      assert %Ecto.Changeset{} = Cashier.change_transaction(transaction)
    end
  end

  describe "withdrawal transactions" do
    test "create_transaction/1 with valid data creates a transaction" do
      checking_account = insert(:checking_account)
      attrs = string_params_for(:withdrawal)

      assert {:ok, %Transaction{} = transaction} =
               Cashier.create_transaction(attrs, checking_account)

      assert transaction.type == attrs["type"]
      assert transaction.value == attrs["value"]
    end

    test "create_transaction/1 with greater value than available" do
      checking_account = insert(:checking_account)
      attrs = string_params_for(:withdrawal, value: checking_account.balance + 10_000)

      assert {:error, :insufficient_funds} = Cashier.create_transaction(attrs, checking_account)
    end
  end

  describe "transfer transactions" do
    test "create_transaction/1 with valid data creates a transaction" do
      to_checking_account = insert(:checking_account)
      from_checking_account = insert(:checking_account)
      attrs = string_params_for(:transfer)

      attrs =
        Map.merge(attrs, %{
          "from_checking_account_id" => from_checking_account.id,
          "to_checking_account_number" => to_checking_account.number
        })

      assert {:ok, %Transaction{} = transaction} =
               Cashier.create_transaction(attrs, to_checking_account)

      assert transaction.type == attrs["type"]
      assert transaction.value == attrs["value"]
    end

    test "create_transaction/1 with greater value than available" do
      to_checking_account = insert(:checking_account)
      from_checking_account = insert(:checking_account)
      attrs = string_params_for(:transfer, value: from_checking_account.balance + 10_000)

      attrs =
        Map.merge(attrs, %{
          "from_checking_account_id" => from_checking_account.id,
          "to_checking_account_number" => to_checking_account.number
        })

      assert {:error, :insufficient_funds} =
               Cashier.create_transaction(attrs, to_checking_account)
    end
  end
end
