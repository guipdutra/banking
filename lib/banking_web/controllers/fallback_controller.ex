defmodule BankingWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.
  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use BankingWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankingWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :insufficient_funds}) do
    conn
    |> put_status(:not_modified)
    |> put_view(BankingWeb.ErrorView)
    |> render(:"304")
  end

  def call(conn, {:error, :invalid_value}) do
    conn
    |> put_status(:not_modified)
    |> put_view(BankingWeb.ErrorView)
    |> render(:"304")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Login error"})
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(BankingWeb.ErrorView)
    |> render(:"404")
  end
end
