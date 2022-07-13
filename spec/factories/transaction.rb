require 'faker'
FactoryBot.define do
  factory :transaction do
    sender_id { Faker::Number.number(digits: 1) }
    receiver_id { Faker::Number.number(digits: 1) }
    amount { Faker::Number.decimal(l_digits: 2) }
  end
end
