defmodule Banking.CheckingAccountsTest do
  use Banking.DataCase
  import Banking.Factory

  alias Banking.Contexts.CheckingAccounts

  describe "checking_accounts" do
    alias Banking.Schemas.CheckingAccount

    @invalid_attrs %{balance: nil, number: nil}

    test "list_checking_accounts/0 returns all checking_accounts" do
      checking_account = insert(:checking_account)
      assert CheckingAccounts.list_checking_accounts() == [checking_account]
    end

    test "get_checking_account!/1 returns the checking_account with given id" do
      checking_account = insert(:checking_account)
      assert CheckingAccounts.get_checking_account!(checking_account.id) == checking_account
    end

    test "get_checking_account_by_number returns checking_account" do
      user = insert(:user, checking_account: params_for(:checking_account))

      checking_account =
        CheckingAccounts.get_checking_account_by_number(user.checking_account.number)

      assert user.checking_account == checking_account
    end

    test "get_checking_account_by_user_and_number returns checking_account" do
      user = insert(:user, checking_account: params_for(:checking_account))

      checking_account =
        CheckingAccounts.get_checking_account_by_user_and_number(
          user.id,
          user.checking_account.number
        )

      assert user.checking_account == checking_account
    end

    test "update_checking_account/2 with valid data updates the checking_account" do
      checking_account = insert(:checking_account)
      update_attrs = %{balance: 50_000}

      assert {:ok, %CheckingAccount{} = checking_account} =
               CheckingAccounts.update_checking_account(checking_account, update_attrs)

      assert checking_account.balance == update_attrs.balance
    end

    test "update_checking_account/2 with invalid data returns error changeset" do
      checking_account = insert(:checking_account)

      assert {:error, %Ecto.Changeset{}} =
               CheckingAccounts.update_checking_account(checking_account, @invalid_attrs)

      assert checking_account == CheckingAccounts.get_checking_account!(checking_account.id)
    end

    test "validate_balance/2 return true" do
      checking_account = insert(:checking_account)

      assert true == CheckingAccounts.validate_balance(checking_account, 10_000)
    end

    test "validate_balance/2 return false" do
      checking_account = insert(:checking_account)

      assert false == CheckingAccounts.validate_balance(checking_account, 200_000)
    end

    test "change_checking_account/1 returns a checking_account changeset" do
      checking_account = build(:checking_account)
      assert %Ecto.Changeset{} = CheckingAccounts.change_checking_account(checking_account)
    end
  end
end
