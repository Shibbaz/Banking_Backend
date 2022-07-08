# Banking

This is a REST API of Banking app.

API uses:
* Ruby 3.1.2
* Rails 6.1.6
* JWT, bcrypt to authenticate the users
* RSpec, testing framework
* Pry, debugger
* Rails Event Store

Initialize an app:
* rails db:create
* rails db:migrate
* rails db:seeds

Credentials needed:
- Postgres
Add db_login and db_password to your rails credentials.
You can do it through EDITOR="vim" rails credentials:edit

If you want to start server:
* rails s

If you want to run all tests using rspec:
* rspec .

Application features:
- User can be authenticated
- User details can be shown
- User can send money to other user
- Transactions are traceable, You can see history of your bank account
- Balance of current user can be shown

Explanation:
- You can find business logic in app/contexts.
- If you want to test endpoints manually through Postman.
  - You need a user with some greater than 0.0 balance to make transactions.
  - There are users with some balance initialized through rails db:seed. 
  - The credentials to those accounts can be found there.
