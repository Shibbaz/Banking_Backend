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
                                              params:,
                                              current_user_id:,
                                              balance: calculate_balance,
                                              adapter:
                                            })
          $event_store.publish(event, stream_name: SecureRandom.uuid)
        end
      end

      def show_sorted_transactions
        ids = current_user_transactions.map(&:id)
        Contexts::Transactions::Queries::Transactions.new.sorted_transactions(ids:, user_id: current_user_id)
      end

      def account_data
        { user_id: current_user_id, balance: calculate_balance, currency: 'USD' }
      end

      def calculate_balance
        User.find(current_user_id).balance
      end

      def current_user_transactions
        transactions_received_by_current_user.or(transactions_sent_by_current_user)
      end

      private
      attr_reader :adapter, :current_user_id
      
      def transactions_received_by_current_user
        Transaction.where(receiver_id: current_user_id)
      end

      def transactions_sent_by_current_user
        Transaction.where(sender_id: current_user_id)
      end
    end
  end
end
