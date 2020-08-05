defmodule Banking.Schemas.CheckingAccount do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checking_accounts" do
    field :balance, :integer
    field :number, :string

    timestamps()
  end

  @doc false
  def changeset(checking_account, attrs) do
    checking_account
    |> cast(attrs, [:number, :balance])
    |> validate_required([:number, :balance])
  end
end
