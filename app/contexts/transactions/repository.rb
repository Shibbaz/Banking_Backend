module Contexts
  module Transactions
    class Repository
      def initialize(current_user_id, adapter: Transaction)
        @adapter = adapter
        @current_user_id = current_user_id
        @current_user_sender_transactions = []
      end

      def create!(params)
        Transaction.transaction do
          event = TransactionWasCreated.new(data: {
                                              params: params,
                                              current_user_id: current_user_id,
                                              balance: calculate_balance,
                                              adapter: adapter
                                            })
          $event_store.publish(event, stream_name: SecureRandom.uuid)
        end
      end

      def show_sorted_transactions
        ids = current_user_transactions.map(&:id)
        Contexts::Transactions::Queries::Transactions.new.sorted_transactions(ids: ids, user_id: current_user_id)
      end

      def account_data
        { user_id: current_user_id, balance: calculate_balance, currency: "USD" }
      end

      def calculate_balance
        (transfered + received).inject(:+)
      end

      def current_user_transactions
        transactions_received_by_current_user.or(transactions_sent_by_current_user)
      end

      private

      attr_reader :adapter, :current_user_sender_transactions, :current_user_id

      def transfered
        current_user_transactions.map(&:sender_id).each_with_index { |element, index|
          current_user_sender_transactions << index if element == current_user_id
        }
        sent_by_current_user_transactions.select { |element| !element.equal?(nil) }
      end

      def sent_by_current_user_transactions
        current_user_transactions.map(&:amount).each_with_index.map { |element, index|
          if current_user_sender_transactions.include?(index)
            Contexts::Helpers::Methods.new.make_negative(element)
          end
        }
      end

      def received
        transactions = current_user_transactions.map(&:amount).reject.each_with_index { |_, index|
          current_user_sender_transactions.include? index
        }
        transactions.empty? ? [0.0] : transactions
      end

      def transactions_received_by_current_user
        Transaction.where(receiver_id: current_user_id)
      end

      def transactions_sent_by_current_user
        Transaction.where(sender_id: current_user_id)
      end
    end
  end
end
