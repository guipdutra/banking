defmodule Banking.TransactionFactory do
  alias Banking.Schemas.Transaction

  defmacro __using__(_opts) do
    quote do
      def withdrawal_factory do
        %Transaction{
          value: 10_000,
          from_checking_account: insert(:checking_account),
          type: "withdrawal"
        }
      end

      def transfer_factory do
        %Transaction{
          value: 10_000,
          to_checking_account: insert(:checking_account),
          from_checking_account: insert(:checking_account),
          type: "transfer"
        }
      end
    end
  end
end
