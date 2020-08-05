defmodule Banking.CheckAdmin do
  import Phoenix.Controller
  import Plug.Conn

  alias Banking.Schemas.User

  def init(opts), do: opts

  def call(conn, _opts) do
    with %User{} = user <- Guardian.Plug.current_resource(conn),
         {:ok, :admin} <- is_admin(user) do
      conn
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Login error"})
        |> halt
    end
  end

  defp is_admin(%{is_admin: true}) do
    {:ok, :admin}
  end

  defp is_admin(_) do
    {:error, :unauthorized}
  end
end
