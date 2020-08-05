defmodule BankingWeb.Router do
  use BankingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Banking.Guardian.AuthPipeline
  end

  pipeline :admin_required do
    plug Banking.CheckAdmin
  end

  scope "/api", BankingWeb do
    pipe_through :api

    post "/sign_up", UserController, :create
    post "/sign_in", UserController, :sign_in
  end

  scope "/api", BankingWeb do
    pipe_through [:api, :jwt_authenticated]

    resources "/transactions", TransactionController, only: [:create, :index, :show]
  end
end
