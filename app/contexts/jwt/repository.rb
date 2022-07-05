require "jwt"
module Contexts
  module Jwt
    class Repository
      attr_reader :adapter
      SECRET_KEY = Rails.application.secret_key_base

      def initialize(adapter: JWT)
        @adapter = adapter
      end

      def jwt_encode(paylod, exp = 7.days.from_now)
        paylod[:exp] = exp.to_i
        @adapter.encode(paylod, SECRET_KEY)
      end

      def jwt_decode(token)
        decoded = @adapter.decode(token, SECRET_KEY)[0]
        HashWithIndifferentAccess.new decoded
      end
    end
  end
end
