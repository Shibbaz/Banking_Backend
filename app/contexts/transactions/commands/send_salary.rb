module Contexts
  module Transactions
    module Commands
      class SendSalary
        def call(event)
          @stream = event.data
          @stream[:adapter].create!(@stream[:params].merge(sender_id: 1000))
        end
      end
    end
  end
end
