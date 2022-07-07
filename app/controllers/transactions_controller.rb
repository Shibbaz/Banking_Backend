class TransactionsController < ApplicationController
  def index
    repository = Contexts::Transactions::Repository.new(@current_user.id)
    render json: repository.show_sorted_transactions, status: :ok
  end

  def create
    params = transaction_params.merge(sender: @current_user.id)
    repository = Contexts::Transactions::Repository.new(@current_user.id)
    repository.create!(params)
    render json: { message: "Transaction was created" }, status: :ok
  end

  def account
    repository = Contexts::Transactions::Repository.new(@current_user.id)
    render json: repository.account_data
  end

  private

  def transaction_params
    params.permit(:receiver, :amount)
  end
end
