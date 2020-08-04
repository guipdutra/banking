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
    end
  end
end
