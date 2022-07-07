class Transaction < ApplicationRecord
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :amount, numericality: true
end
