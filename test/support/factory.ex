defmodule Banking.Factory do
  use ExMachina.Ecto, repo: Banking.Repo

  use Banking.{
    UserFactory
  }
end
