class UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [:create]
    before_action :set_user, only: [:show, :destroy]

    def index
        render json: @current_user, except: [:password_digest], status: :ok
    end

    def show
        render json: @user, status: :ok
    end

    def create
        @user = Contexts::Users::Repository.new.create!(user_params)
        if @user.save
            render json: @user, status: :created
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        unless Contexts::Users::Repository.new.update(user_params)
            render json: { errors: @user.errors.full_messages}, status: :unprocessable_entity
        end
    end

    def destroy
        @user.destroy
    end

    private

        def user_params
            params.permit(:name, :username, :email, :password)
        end

        def set_user
            @user = Contexts::Users::Repository.new.find(params[:id])
        end
end
