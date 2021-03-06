require 'rails_helper'
require 'faker'

RSpec.describe Contexts::Transactions::Repository, type: :model do
  subject(:user) do
    create(:user)
  end
  subject(:extra_user) do
    create(:user)
  end
  subject(:repository) do
    Contexts::Transactions::Repository.new(user.id)
  end
  subject(:transaction) do
    Transaction.new(sender_id: 1000, receiver_id: user.id, amount: 1000.0)
  end
  subject(:extra_transaction) do
    Transaction.new(sender_id: 1000, receiver_id: extra_user.id, amount: 1000.0)
  end
  before do
    transaction.save!
    extra_transaction.save!
  end

  context 'when object is initialized' do
    it 'success' do
      expect { repository }.to_not raise_error
    end
  end

  context 'when calculating balance method' do
    it 'calculates balance' do
      expect(repository.calculate_balance).to eq(1000)
      Transaction.create!(sender_id: user.id, receiver_id: extra_user.id, amount: 100.0)
      expect(repository.calculate_balance).to eq(900)
    end
  end

  context 'when returning current user transactions' do
    it 'returns current user transactions' do
      expect(repository.current_user_transactions.length).to eq(1)
      expect(repository.current_user_transactions).to eq([transaction])
      Transaction.create!(sender_id: user.id, receiver_id: extra_user.id, amount: 100.0)
      expect(repository.current_user_transactions.length).to eq(2)
    end
  end

  context 'when returning account_data hash' do
    it 'returns account datas' do
      expect(repository.account_data).to eq({ user_id: user.id, balance: 1000, currency: 'USD' })
    end
  end

  context 'when returning current user sorted transactions method' do
    it 'returns sorted transactions' do
      Transaction.create!(sender_id: user.id, receiver_id: extra_user.id, amount: 100.0)
      expect(repository.show_sorted_transactions.length).to eq(2)
    end
  end

  context 'when creating a new Transaction' do
    let(:params) do
      {
        receiver_id: extra_user.id,
        amount: 1.0
      }
    end

    it 'success when creating a transaction' do
      event_store = repository.create!(params)
      expect(event_store).to have_published(an_event(TransactionWasCreated))
    end
  end
end
