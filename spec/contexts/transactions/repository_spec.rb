require "rails_helper"
require "faker"

RSpec.describe Contexts::Transactions::Repository, type: :model do
  let(:user) {
    create(:user)
  }
  let(:extra_user) {
    create(:user)
  }
  let(:repository) {
    Contexts::Transactions::Repository.new(user.id)
  }
  let(:transaction) {
    Transaction.new(sender: 1000, receiver: user.id, amount: 1000.0)
  }
  let(:extra_transaction) {
    Transaction.new(sender: 1000, receiver: extra_user.id, amount: 1000.0)
  }
  before do
    transaction.save!
    extra_transaction.save!
  end

  context "constructor method" do
    it "success" do
      expect { repository }.to_not raise_error
    end
  end

  context "calculate balance method" do
    it "calculates balance" do
      expect(repository.calculate_balance).to eq(1000)
      Transaction.create!(sender: user.id, receiver: extra_user.id, amount: 100.0)
      expect(repository.calculate_balance).to eq(900)
    end
  end

  context "current_user_transactions method" do
    it "returns current user transactions" do
      expect(repository.current_user_transactions.length).to eq(1)
      expect(repository.current_user_transactions).to eq([transaction])
      Transaction.create!(sender: user.id, receiver: extra_user.id, amount: 100.0)
      expect(repository.current_user_transactions.length).to eq(2)
    end
  end

  context "account_data method" do
    it "returns account datas" do
      expect(repository.account_data).to eq({ user_id: user.id, balance: 1000, currency: "USD" })
    end
  end

  context "account_data method" do
    it "returns sorted transactions" do
      Transaction.create!(sender: user.id, receiver: extra_user.id, amount: 100.0)
      expect(repository.show_sorted_transactions.length).to eq(2)
    end
  end

  context "create! method" do
    it "success" do
      params = {
        receiver: extra_user.id,
        amount: 1.0
      }
      event_store = repository.create!(params)
      expect(event_store).to have_published(an_event(TransactionWasCreated))
    end
  end
end