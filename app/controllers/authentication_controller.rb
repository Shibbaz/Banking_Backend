class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def login
    repository = Contexts::Users::Repository.new
    @user = repository.find_by_email(params[:email])
    if repository.authenticate(params[:email], password: params[:password])
      token = repository.token
      render json: {token: token}, status: :ok
    else
      render json: {error: "unauthorized"}, status: :unauthorized
    end
  end
end
