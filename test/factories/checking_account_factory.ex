defmodule Banking.CheckingAccountFactory do
  alias Banking.Schemas.CheckingAccount

  defmacro __using__(_opts) do
    quote do
      def checking_account_factory do
        %CheckingAccount{
          number: to_string(:rand.uniform()),
          balance: 100_000
        }
      end
    end
  end
end
