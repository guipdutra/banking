defmodule Banking.Contexts.AccountsTest do
  use Banking.DataCase

  alias Banking.Contexts.Accounts

  import Banking.Factory

  describe "users" do
    alias Banking.Schemas.User

    @valid_attrs params_for(:user)
    @invalid_attrs %{email: nil, name: nil, password: nil}

    setup do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      {:ok, user: user}
    end

    test "get_user!/1 returns the user with given id", %{user: user} do
      user_return = Accounts.get_user!(user.id)

      assert user_return.name == user.name
      assert user_return.email == user.email
    end

    test "create_user/1 with valid data creates a user", %{user: user} do
      assert user.email == @valid_attrs.email
      assert user.name == @valid_attrs.name
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 with invalid password returns error changeset" do
      user_attrs = params_for(:user, password: "passwd")

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  password: {
                    "should be at least %{count} character(s)",
                    [count: 8, validation: :length, kind: :min, type: :string]
                  }
                ]
              }} = Accounts.create_user(user_attrs)
    end

    test "create_user/1 with invalid email returns error changeset" do
      user_attrs = params_for(:user, email: "invalid.com.br")

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  email: {
                    "has invalid format",
                    [validation: :format]
                  }
                ]
              }} = Accounts.create_user(user_attrs)
    end

    test "create_user/1 when email already been taken" do
      user = insert(:user)
      user_attrs = params_for(:user, email: user.email)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  email:
                    {"has already been taken",
                     [constraint: :unique, constraint_name: "users_email_index"]}
                ]
              }} = Accounts.create_user(user_attrs)
    end
  end
end
