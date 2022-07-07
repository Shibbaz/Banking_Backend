module Contexts
  module Transactions
    module Queries
      class ShowSortedTransactions
        def call(ids:, user_id:)
          data = Transaction.where(id: ids).order("created_at DESC").map { |element|
            if element.sender == user_id
              Transaction.new(
                id: element.id,
                sender: element.sender,
                receiver: element.receiver,
                amount: Contexts::Helpers::Methods.new.make_negative(element.amount),
                currency: "USD",
                created_at: element.created_at,
                updated_at: element.updated_at
              )
            else
              element
            end
          }
        end
      end
    end
  end
end
