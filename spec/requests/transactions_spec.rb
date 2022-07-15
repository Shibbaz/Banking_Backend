require 'rails_helper'
require 'faker'

RSpec.describe 'Transactions', type: :request do
  describe 'GET /transactions' do
    subject(:user) do
      create(:user, password: 'test1234')
    end
    let(:token) do
      post '/auth/login', params: {
        email: user.email,
        password: 'test1234'
      }
      JSON(response.body)['token']
    end

    before do
      Transaction.create!(sender_id: 1000, receiver_id: user.id, amount: 1000.0)
    end

    it 'succeces in accessing /transactions page' do
      get '/transactions', headers: { Authorization: token }
      expect(response.status).to eq(200)
    end

    it 'fails accessing /transactions page' do
      expect { get '/transactions', headers: { Authorization: 'token' } }.to raise_error(JWT::DecodeError)
    end

    it 'succeces in accessing /balance page' do
      get '/balance', headers: { Authorization: token }
      expect(JSON(response.body)['balance'].to_i).to eq(1000)
      expect(response.status).to eq(200)
    end

    it 'fails accessing /balance page' do
      expect { get '/balance', headers: { Authorization: 'token' } }.to raise_error(JWT::DecodeError)
    end
  end

  describe 'POST /users' do
    subject(:user) do
      create(:user, password: 'test1234')
    end
    let(:token) do
      post '/auth/login', params: {
        email: user.email,
        password: 'test1234'
      }
      JSON(response.body)['token']
    end

    subject(:extra_user) do
      create(:user, password: 'test1234')
    end
    let(:extra_token) do
      post '/auth/login', params: {
        email: extra_user.email,
        password: 'test1234'
      }
      JSON(response.body)['token']
    end
    let(:user_params) do
      {
        sender_id: 1000, receiver_id: user.id, amount: 1000.0
      }
    end
    let(:extra_user_params) do
      {
        sender_id: 1000, receiver_id: extra_user.id, amount: 1000.0
      }
    end
    before do
      Transaction.create!(user_params)
      Transaction.create!(extra_user_params)
    end

    it 'creates new transaction' do
      post '/transactions', params: {
        receiver_id: extra_user.id,
        amount: 1.0
      }, headers: { Authorization: token }

      expect(response).to have_http_status(:ok)
    end

    it "fails creating new transaction. Receiver can't be sender" do
      expect do
        post '/transactions', params: {
          receiver_id: user.id,
          amount: 1.0
        }, headers: { Authorization: token }
      end.to raise_error(StandardError)
    end

    it 'sends back money' do
      post '/transactions', params: {
        receiver_id: extra_user.id,
        amount: 1.0
      }, headers: { Authorization: token }

      expect(response).to have_http_status(:ok)
      expect(Contexts::Transactions::Repository.new(user.id).calculate_balance).to eq(999.0)
      expect(Contexts::Transactions::Repository.new(extra_user.id).calculate_balance).to eq(1001.0)
      post '/transactions', params: {
        receiver_id: user.id,
        amount: 1.0
      }, headers: { Authorization: extra_token }
      expect(Contexts::Transactions::Repository.new(user.id).calculate_balance).to eq(1000.0)
      expect(Contexts::Transactions::Repository.new(extra_user.id).calculate_balance).to eq(1000.0)
      expect(response).to have_http_status(:ok)
    end

    context 'when sending few transactions'
    let(:new_user)  do
      create(:user, password: 'test1234')
    end
    before do
      create(:transaction, receiver_id: new_user.id, amount: 1000)
      create(:user, password: 'test1234')
    end

    let(:new_token) do
      post '/auth/login', params: {
        email: new_user.email,
        password: 'test1234'
      }
      JSON(response.body)['token']
    end

    it 'sends multiple succesful transactions' do
      expect  do
        receiver_id = User.last.id
        50.times do
          post '/transactions', params: {
            receiver_id:,
            amount: 20.0
          }, headers: { Authorization: new_token }
        end
      end.to_not raise_error
    end

    it 'sends untill balance is 0' do
      expect  do
        receiver_id = User.last.id
        100.times do
          post '/transactions', params: {
            receiver_id:,
            amount: 300.0
          }, headers: { Authorization: new_token }
        end
      end.to raise_error(StandardError)
    end
  end
end
