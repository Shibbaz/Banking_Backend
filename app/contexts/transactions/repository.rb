module Contexts
  module Transactions
    class Repository
      attr_reader :adapter

      def initialize(current_user_id, adapter: Transaction)
        @adapter = adapter
        @current_user_id = current_user_id
      end

      def create!(params)
        ActiveRecord::Base.transaction do
          event = TransactionWasCreated.new(data: {
            params: params,
            current_user_id: @current_user_id,
            balance: calculate_balance,
            adapter: @adapter
          })
          $event_store.publish(event, stream_name: SecureRandom.uuid)
        end
      end

      def account_data
        {user_id: @current_user_id, balance: calculate_balance, currency: "USD"}
      end

      def calculate_balance
        transactions = current_user_transactions
        resultNegatives = []
        negativeIds = transactions.map(&:sender).each_with_index { |element, index| resultNegatives << index if element == @current_user_id }

        sentMoney = transactions.map(&:amount).each_with_index.map { |element, index|
          if resultNegatives.include?(index)
            make_negative(element)
          end
        }
        transfered = sentMoney.select { |element| !element.equal?(nil) }
        received = transactions.map(&:amount).reject.each_with_index { |i, ix| resultNegatives.include? ix }.empty? ? [0.0] : transactions.map(&:amount).reject.each_with_index { |i, ix| resultNegatives.include? ix }
        (received + transfered).inject(:+)
      end

      def current_user_transactions
        Transaction.where(receiver: @current_user_id).or(Transaction.where(sender: @current_user_id))
      end

      def make_negative(num)
        num <= 0 ? num : num * -1
      end
    end
  end
end
