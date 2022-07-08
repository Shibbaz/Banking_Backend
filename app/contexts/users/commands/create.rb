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
          Transaction.transaction do
            event = SalaryWasSentToUser.new(data: {
                                              params: params,
                                              adapter: Transaction
                                            })
            $event_store.publish(event, stream_name: SecureRandom.uuid)
          end
        end
      end
    end
  end
end
