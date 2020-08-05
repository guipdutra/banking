defmodule Banking.AuthTest do
  use Banking.DataCase

  alias Banking.Contexts.Accounts
  alias Banking.Schemas.User
  alias Banking.Auth
  import Banking.Factory

  @valid_attrs params_for(:user)

  setup do
    assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
    {:ok, user: user}
  end

  describe "authenticate" do
    test "authenticate user", %{user: user} do
      assert {:ok, user, token} = Auth.authenticate(user.email, user.password)
    end

    test "given wrong password it returns error", %{user: user} do
      assert {:error, :unauthorized} = Auth.authenticate(user.email, "other")
    end
  end
end
