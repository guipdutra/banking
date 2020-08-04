defmodule BankingWeb.Router do
  use BankingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankingWeb do
    pipe_through :api

    post "/sign_up", UserController, :create
    post "/sign_in", UserController, :sign_in
  end
end
