class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  def index
    render json: @current_user, except: [:password_digest], status: :ok
  end

  def create
    @user = Contexts::Users::Repository.new.create!(user_params)
    render json: {message: "User was created"}, status: :ok
  end

  private

  def user_params
    params.permit(:name, :username, :email, :password)
  end
end
