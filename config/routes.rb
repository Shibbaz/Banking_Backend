Rails.application.routes.draw do
  resources :users
  resources :transactions
  get '/balance', to: 'transactions#account'
  post '/auth/login', to: 'authentication#login'
end
