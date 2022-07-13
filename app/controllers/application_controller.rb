class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    repository = Contexts::Jwt::Repository.new
    decoded = repository.jwt_decode(header)
    @current_user = Contexts::Users::Repository.new.find(decoded[:user_id])
  end
end
