module Contexts
  module Transactions
    module Commands
      class Create
        def call(event)
          @stream = event.data
          check_if_errors_were_raised!
          @stream[:adapter].create!(@stream[:params].merge(sender_id: current_user_id))
        end

        private

        attr_reader :stream, :receiver_id, :current_user_id, :amount, :balance

        def check_if_errors_were_raised!
          @receiver_id = @stream[:params][:receiver_id].to_i
          @current_user_id = @stream[:current_user_id]
          @amount = @stream[:params][:amount].to_d
          @balance = @stream[:balance]

          validate_amount!
          validate_if_receiver_is_sender!
          validate_balance!
          validate_receiver!
        end

        def validate_if_receiver_is_sender!
          raise StandardError, "Receiver can't be sender" if receiver_id.equal?(current_user_id)
        end

        def validate_amount!
          raise StandardError, "Amount can't be 0 or below" if (amount) <= 0.0
        end

        def validate_balance!
          raise StandardError, 'Balance have to be greater or equal 0' if (balance - amount) < 0.0
        end

        def validate_receiver!
          receiver ||= User.find(receiver_id)
          raise ActiveRecord::RecordNotFound if receiver.nil?
        end
      end
    end
  end
end
