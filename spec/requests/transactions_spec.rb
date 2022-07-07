require "rails_helper"
require "faker"

RSpec.describe "Transactions", type: :request do
  describe "GET /transactions" do
    let(:user) {
      create(:user, password: "test1234")
    }
    let(:token) {
      post "/auth/login", params: {
        email: user.email,
        password: "test1234"
      }
      JSON(response.body)["token"]
    }

    before do
      Transaction.create!(sender_id: 1000, receiver_id: user.id, amount: 1000.0)
    end

    it "succeces in accessing /transactions page" do
      get "/transactions", headers: { Authorization: token }
      expect(response.status).to eq(200)
    end

    it "fails accessing /transactions page" do
      expect { get "/transactions", headers: { Authorization: "token" } }.to raise_error(JWT::DecodeError)
    end

    it "succeces in accessing /balance page" do
      get "/balance", headers: { Authorization: token }
      expect(JSON(response.body)["balance"].to_i).to eq(1000)
      expect(response.status).to eq(200)
    end

    it "fails accessing /balance page" do
      expect { get "/balance", headers: { Authorization: "token" } }.to raise_error(JWT::DecodeError)
    end
  end

  describe "POST /users" do
    let(:user) {
      create(:user, password: "test1234")
    }
    let(:token) {
      post "/auth/login", params: {
        email: user.email,
        password: "test1234"
      }
      JSON(response.body)["token"]
    }

    let(:extra_user) {
      create(:user, password: "test1234")
    }
    let(:extra_token) {
      post "/auth/login", params: {
        email: extra_user.email,
        password: "test1234"
      }
      JSON(response.body)["token"]
    }
    before do
      Transaction.create!(sender_id: 1000, receiver_id: user.id, amount: 1000.0)
      Transaction.create!(sender_id: 1000, receiver_id: extra_user.id, amount: 1000.0)
    end

    it "creates new transaction" do
      post "/transactions", params: {
        receiver_id: extra_user.id,
        amount: 1.0
      }, headers: { Authorization: token }

      expect(response).to have_http_status(:ok)
    end

    it "fails creating new transaction. Receiver can't be sender" do
      expect {
        post "/transactions", params: {
          receiver_id: user.id,
          amount: 1.0
        }, headers: { Authorization: token }
      }.to raise_error(StandardError)
    end

    it "sends back money" do
      post "/transactions", params: {
        receiver_id: extra_user.id,
        amount: 1.0
      }, headers: { Authorization: token }

      expect(response).to have_http_status(:ok)
      expect(Contexts::Transactions::Repository.new(user.id).calculate_balance).to eq(999.0)
      expect(Contexts::Transactions::Repository.new(extra_user.id).calculate_balance).to eq(1001.0)
      post "/transactions", params: {
        receiver_id: user.id,
        amount: 1.0
      }, headers: { Authorization: extra_token }
      expect(Contexts::Transactions::Repository.new(user.id).calculate_balance).to eq(1000.0)
      expect(Contexts::Transactions::Repository.new(extra_user.id).calculate_balance).to eq(1000.0)
      expect(response).to have_http_status(:ok)
    end
  end
end
