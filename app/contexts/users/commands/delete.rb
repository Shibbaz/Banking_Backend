module Contexts
    module Users
        module Commands
            class Delete
                def call(event)
                    stream = event.data
                    user = stream[:adapter].delete(stream[:id])
                end
            end
        end
    end
end