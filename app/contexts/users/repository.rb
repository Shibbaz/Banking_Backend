module Contexts
  module Users
    class Repository
      attr_reader :adapter, :user

      def initialize(adapter: User)
        @adapter = adapter
      end

      def create!(params)
        User.transaction do
          event = UserWasCreated.new(data: {
                                       params:,
                                       adapter:
                                     })
          $event_store.publish(event, stream_name: SecureRandom.uuid)
        end
      end

      delegate :find, to: :adapter

      def find_by_email(email)
        adapter.find_by(email:)
      end

      def authenticate(email, password:)
        @user = adapter.find_by_email(email)
        user&.authenticate(password)
      end

      def token
        Contexts::Jwt::Repository.new.jwt_encode(user_id: user.id)
      end
    end
  end
end
