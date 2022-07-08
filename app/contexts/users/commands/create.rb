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
          params = { receiver_id: user.id, amount: 1000, currency: "USD" }
        end
      end
    end
  end
end
