class ApplicationController < ActionController::API

    before_action :authenticate_request

    private
        def authenticate_request
            header = request.headers["Authorization"]
            header = header.split(" ").last if header
            repository = Contexts::Jwt::Repository.new
            decoded = repository.decode(header)
            @current_user = Contexts::Users::Repository.new.find(decoded[:user_id])
        end

end
