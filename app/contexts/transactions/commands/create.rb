module Contexts
  module Transactions
    module Commands
      class Create
        def call(event)
          stream = event.data
          receiverId = stream[:params][:receiver].to_i
          raise StandardError.new "Receiver can't be sender" if receiverId.equal?(stream[:current_user_id])
          raise StandardError.new "Sent Amount can't be bigger than Balance" if (stream[:balance] - stream[:params][:amount].to_i) <= 0
          receiver ||= User.find(receiverId)
          raise ActiveRecord::RecordNotFound if receiver.nil?
          stream[:adapter].create!(stream[:params].merge(sender: stream[:current_user_id]))
        end
      end
    end
  end
end
