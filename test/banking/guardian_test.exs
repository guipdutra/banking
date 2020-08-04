defmodule Banking.GuardianTest do
  use Banking.DataCase

  alias Banking.Contexts.Accounts
  alias Banking.Schemas.User
  alias Banking.Guardian
  import Banking.Factory

  @valid_attrs params_for(:user)

  setup do
    assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
    {:ok, user: user}
  end

  describe "authenticate" do
    test "authenticate user", %{user: user} do
      assert {:ok, user, token} = Guardian.authenticate(user.email, user.password)
    end

    test "given wrong password it returns error", %{user: user} do
      assert {:error, :unauthorized} = Guardian.authenticate(user.email, "other")
    end
  end
end
