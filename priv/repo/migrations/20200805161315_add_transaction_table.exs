defmodule Banking.Repo.Migrations.AddTransactionTable do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :value, :integer
      add :type, :string
      add :from_checking_account_id, references(:checking_accounts, on_delete: :nothing)
      add :to_checking_account_id, references(:checking_accounts, on_delete: :nothing)

      timestamps()
    end

    create index(:transactions, [:from_checking_account_id])
    create index(:transactions, [:to_checking_account_id])
  end
end
