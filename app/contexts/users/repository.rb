module Contexts
    module Users
        class Repository
            attr_reader :adapter

            def initialize(adapter: User)
                @adapter = adapter
            end

            def create!(params)
                @adapter.new(params)
            end

            def update!(params)
                @adapter.update(params)
            end

            def delete!(id)
                @adapter.delete(id)
            end

            def find(id)
                @adapter.find(id)
            end

            def find_by_email(email)
                @adapter.find_by(email: email) 
            end

            def authenticate(email, password:)
                @user = @adapter.find_by_email(email)
                @user&.authenticate(password)
            end

            def token
                return Contexts::Jwt::Repository.new.jwt_encode(user_id: @user.id)
            end
        end
    end
end