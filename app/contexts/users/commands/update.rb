module Contexts
    module Users
        module Commands
            class Update
                def call(event)
                    stream = event.data
                    user = stream[:adapter].find(stream[:id]).update!(
                        stream[:params]
                    )
                end
            end
        end
    end
end