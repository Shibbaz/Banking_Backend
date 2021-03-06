require 'rails_helper'

RSpec.describe Transaction, type: :model do
  context 'when creating a Transaction' do
    it 'is valid with valid attributes' do
      expect { create(:transaction) }.to_not raise_error
    end

    it 'is not valid without a sender' do
      expect { create(:transaction, sender_id: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is not valid without a receiver' do
      expect { create(:transaction, receiver_id: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is not valid without a amount' do
      expect { create(:transaction, amount: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
