defmodule BankingWeb.UserControllerTest do
  use BankingWeb.ConnCase

  import Banking.Factory
  alias Banking.Contexts.Accounts

  @create_attrs params_for(:user)
  @invalid_attrs %{email: nil, name: nil, password: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert response = json_response(conn, 200)["data"]

      user = Accounts.get_user!(response["user"]["id"])

      assert user.id == response["user"]["id"]
      assert user.name == response["user"]["name"]
      assert user.email == response["user"]["email"]
    end

    test "renders error when password is invalid", %{conn: conn} do
      user_attrs = params_for(:user, password: "passwd")
      conn = post(conn, Routes.user_path(conn, :create), user: user_attrs)

      assert %{"errors" => %{"password" => ["should be at least 8 character(s)"]}} ==
               json_response(conn, 422)
    end

    test "renders error when email is invalid", %{conn: conn} do
      user_attrs = params_for(:user, email: "invalid.com.br")
      conn = post(conn, Routes.user_path(conn, :create), user: user_attrs)

      assert %{"errors" => %{"email" => ["has invalid format"]}} == json_response(conn, 422)
    end

    test "renders error when email already been taken", %{conn: conn} do
      user = insert(:user)
      user_attrs = params_for(:user, email: user.email)
      conn = post(conn, Routes.user_path(conn, :create), user: user_attrs)

      assert %{"errors" => %{"email" => ["has already been taken"]}} = json_response(conn, 422)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "sign_in" do
    alias Banking.Contexts.Accounts

    setup %{conn: conn} do
      {:ok, conn: put_req_header(conn, "accept", "application/json"), user: create_user()}
    end

    test "renders jwt token when data is valid", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_path(conn, :sign_in), %{email: user.email, password: user.password})

      assert %{"jwt" => _token} = json_response(conn, 200)
    end

    test "returns error when password is invalid", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_path(conn, :sign_in), %{email: user.email, password: "wrongpasswd"})

      assert %{"error" => "Login error"} == json_response(conn, 401)
    end

    test "returns error when email do not exist", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_path(conn, :sign_in), %{
          email: "wrongemail@wrong.com",
          password: user.password
        })

      assert %{"error" => "Login error"} == json_response(conn, 401)
    end

    defp create_user() do
      user_attrs = params_for(:user)
      {:ok, user} = Accounts.create_user(user_attrs)

      user
    end
  end
end
