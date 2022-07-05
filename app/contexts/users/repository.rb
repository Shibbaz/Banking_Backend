module Contexts
  module Users
    class Repository
      attr_reader :adapter

      def initialize(adapter: User)
        @adapter = adapter
      end

      def create!(params)
        event = UserWasCreated.new(data: {
          params: params,
          adapter: @adapter
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
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
        Contexts::Jwt::Repository.new.jwt_encode(user_id: @user.id)
      end
    end
  end
end
