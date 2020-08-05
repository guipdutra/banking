defmodule BankingWeb.UserController do
  use BankingWeb, :controller

  alias Banking.Contexts.Accounts
  alias Banking.Schemas.User
  alias Banking.Auth

  action_fallback BankingWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <-
           user_params
           |> Accounts.create_user(),
         {:ok, token, _claims} <-
           Auth.encode_and_sign(user) do
      conn |> render("show.json", %{jwt: token, user: user})
    end
  end

  def create(conn, %{"admin" => admin_params}) do
    with {:ok, %User{} = admin} <-
      admin_params
      |> Map.merge(%{"is_admin" => true})
      |> Accounts.create_user(),
         {:ok, token, _claims} <-
           Auth.encode_and_sign(admin) do
      conn |> render("show.json", %{jwt: token, admin: admin})
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Auth.authenticate(email, password) do
      {:ok, _user, token} ->
        conn |> render("jwt.json", jwt: token)

      _ ->
        {:error, :unauthorized}
    end
  end
end
