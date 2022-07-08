# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

first = User.create!(username: 'epamer', name: 'epamer', email: 'test@epam.com', password: 'epam1234')
second = User.create(username: 'epamer2', name: 'epamer', email: 'test2@epam.com', password: 'epam1234')

Transaction.create!(sender_id: 1000, receiver_id: first.id, amount: 100_000, currency: 'USD')
Transaction.create!(sender_id: 1000, receiver_id: second.id, amount: 100_000, currency: 'USD')
