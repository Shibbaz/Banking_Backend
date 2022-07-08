module Contexts
  module Users
    module Commands
      class Create
        def call(event)
          stream = event.data
          user = stream[:adapter].create!(
            stream[:params]
          )
        end
      end
    end
  end
end
