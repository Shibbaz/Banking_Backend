module Contexts
  module Users
    module Commands
      class Create
        def call(event)
          stream = event.data
          user = stream[:adapter].create!(
            stream[:params]
          )
          user.save!
          ActiveRecord::Base.transaction do
            Transaction.create!({ sender_id: 1000, receiver_id: user.id, amount: 1000.0 })
          end
        end
      end
    end
  end
end
