defmodule BankingWeb.UserView do
  use BankingWeb, :view
  alias BankingWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user, jwt: token}) do
    %{data: render(UserView, "user.json", %{user: user, jwt: token})}
  end

  def render("user.json", %{user: user, jwt: token}) do
    %{
      user: %{
        id: user.id,
        email: user.email,
        name: user.name
      },
      token: token
    }
  end
end
