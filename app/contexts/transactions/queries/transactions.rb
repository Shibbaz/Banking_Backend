module Contexts
  module Transactions
    module Queries
      class Transactions
        def sorted_transactions(ids:, user_id:)
          data = Transaction.where(id: ids).order('created_at DESC').map do |element|
            if element.sender_id == user_id
              Transaction.new(
                id: element.id,
                sender_id: element.sender_id,
                receiver_id: element.receiver_id,
                amount: Contexts::Helpers::Methods.new.make_negative(element.amount),
                currency: 'USD',
                created_at: element.created_at,
                updated_at: element.updated_at
              )
            else
              element
            end
          end
        end
      end
    end
  end
end
