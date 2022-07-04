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
                end
            end
        end
    end
end