class Transaction < ApplicationRecord
    validates :sender, presence: true
    validates :receiver, presence: true
    validates :amount, numericality: true    
end
