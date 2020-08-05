defmodule Banking.Schemas.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Banking.Schemas.CheckingAccount

  @required_fields ~w(type value)a
  @optional_fields ~w(from_checking_account_id to_checking_account_id)a

  schema "transactions" do
    field :type, :string
    field :value, :integer
    belongs_to :from_checking_account, CheckingAccount
    belongs_to :to_checking_account, CheckingAccount

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
