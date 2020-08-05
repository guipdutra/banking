defmodule Banking.UserFactory do
  alias Banking.Schemas.User

  alias Faker.Internet

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          name: Internet.user_name(),
          email: Internet.email(),
          password: "longpassword"
        }
      end

      def admin_factory do
        %User{
          name: Internet.user_name(),
          email: Internet.email(),
          password: "passwd1234",
          is_admin: true
        }
      end
    end
  end
end
