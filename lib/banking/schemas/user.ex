defmodule Banking.Schemas.User do
  @moduledoc """
  User Schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :is_admin, :boolean

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password, :is_admin])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:email)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :encrypted_password, Bcrypt.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
