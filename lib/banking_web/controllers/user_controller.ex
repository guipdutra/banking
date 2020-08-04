defmodule BankingWeb.UserController do
  use BankingWeb, :controller

  alias Banking.Contexts.Accounts
  alias Banking.Schemas.User
  alias Banking.Guardian

  action_fallback BankingWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <-
           user_params
           |> Accounts.create_user(),
         {:ok, token, _claims} <-
           Guardian.encode_and_sign(user) do
      conn |> render("show.json", %{jwt: token, user: user})
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, user, token} ->
        conn |> render("jwt.json", jwt: token)

      _ ->
        {:error, :unauthorized}
    end
  end
end
