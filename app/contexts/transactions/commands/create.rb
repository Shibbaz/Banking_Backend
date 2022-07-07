module Contexts
  module Transactions
    module Commands
      class Create
        def call(event)
          stream = event.data

          receiver_id = stream[:params][:receiver_id].to_i
          current_user_id = stream[:current_user_id]
          amount = stream[:params][:amount].to_d
          balance = stream[:balance]
          raise StandardError.new "Amount can't be 0 or below" if (amount) <= 0.0
          raise StandardError.new "Receiver can't be sender" if receiver_id.equal?(current_user_id)
          raise StandardError.new "Amount can't be bigger than Balance" if (balance - amount) < 0.0

          validate_receiver(receiver_id)

          stream[:adapter].create!(stream[:params].merge(sender_id: current_user_id))
        end

        private

        def validate_receiver(id)
          receiver_id ||= User.find(id)
          raise ActiveRecord::RecordNotFound if receiver_id.nil?
        end
      end
    end
  end
end
