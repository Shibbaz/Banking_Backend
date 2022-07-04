require 'jwt'
module JsonWebToken
    extend ActiveSupport::Concern
    SECRET_KEY = Rails.application.secret_key_base

    def jwt_encode(paylod, exp = 7.days.from_now)
        paylod[:exp] = exp.to_i
        JWT.encode(paylod, SECRET_KEY)
    end

    def jwt_decode(token)
        decoded = JWT.decode(token, SECRET_KEY)[0]
        HashWithIndifferentAccess.new decoded
    end
end