require "faker"
FactoryBot.define do
  factory :transaction do
    sender { Faker::Number.number(digits: 1) }
    receiver { Faker::Number.number(digits: 1) }
    amount { Faker::Number.decimal(l_digits: 2) }
  end
end
