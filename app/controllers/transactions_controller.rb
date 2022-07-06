class TransactionsController < ApplicationController
  def index
    repository = Contexts::Transactions::Repository.new(@current_user.id)
    ids = (repository.current_user_transactions).map(&:id)
    data = Transaction.where(id: ids).order("created_at DESC").map { |element|
      if element.sender == @current_user.id
        Transaction.new(
          id: element.id,
          sender: element.sender,
          receiver: element.receiver,
          amount: repository.make_negative(element.amount),
          currency: "USD",
          created_at: element.created_at,
          updated_at: element.updated_at
        )
      else
        element
      end
    }
    render json: data, status: :ok
  end

  def create
    params = transaction_params.merge(sender: @current_user.id)
    repository = Contexts::Transactions::Repository.new(@current_user.id)
    repository.create!(params)

    render json: {message: "Transaction was created"}, status: :ok
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
