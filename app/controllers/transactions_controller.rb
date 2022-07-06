class TransactionsController < ApplicationController
  def show
    transactionIds = (sum).map(&:id)
    render json: Transaction.where(id: transactionIds).order("created_at DESC"), status: :ok
  end

  def create
    receiverId = transaction_params[:receiver].to_i
    raise StandardError.new "Receiver can't be sender" if receiverId.equal?(@current_user.id)
    raise StandardError.new "Sent Amount can't be bigger than Balance" if transaction_params[:amount].to_i > balance
    receiver ||= User.find(receiverId)
    raise ActiveRecord::RecordNotFound if receiver.nil?
    @user = Transaction.create!(transaction_params.merge(sender: @current_user.id))
    render json: {message: "Transaction was created"}, status: :ok
  end

  def account
    render json: {user_id: @current_user.id, balance: balance, currency: "USD"}
  end

  private

  def sum
    Transaction.where(receiver: @current_user.id).or(Transaction.where(sender: @current_user.id))
  end

  def make_negative(num)
    num <= 0 ? num : num * -1
  end

  def balance
    transactions = sum
    resultNegatives = []

    negativeIds = transactions.map(&:sender).each_with_index { |element, index| resultNegatives << index if element == @current_user.id }

    sentMoney = transactions.map(&:amount).each_with_index.map { |element, index|
      if resultNegatives.include?(index)
        make_negative(element)
      end
    }
    sentMoney.reject! { |element| element.equal?(nil) }.inject(:+) + transactions.map(&:amount).reject.each_with_index { |i, ix| resultNegatives.include? ix }.inject(:+)
  end

  def transaction_params
    params.permit(:receiver, :amount)
  end
end
