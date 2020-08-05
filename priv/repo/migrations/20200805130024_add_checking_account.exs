defmodule Banking.Repo.Migrations.AddCheckingAccount do
  use Ecto.Migration

  def change do
    create table(:checking_accounts) do
      add :number, :string, null: false
      add :balance, :integer, null: false

      timestamps()
    end

    alter table(:users) do
      add :checking_account_id, references(:checking_accounts)
    end

    create index(:users, [:checking_account_id])
  end
end
