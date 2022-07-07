require "rails_helper"
require "faker"

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    before do
      create(:user, password: "test1234")
      email = User.first.email
      post "/auth/login", params: {
        email: email,
        password: "test1234"
      }
      @token = JSON(response.body)["token"]
    end

    it "succeces in accessing /users page" do
      get "/users", headers: { Authorization: @token }
      expect(response.status).to eq(200)
    end

    it "fails accessing /users page" do
      expect { get "/users", headers: { Authorization: "token" } }.to raise_error(JWT::DecodeError)
    end
  end

  describe "POST /users" do
    before do
      create(:user)
    end

    it "creates new user" do
      post "/users", params: {
        name: Faker::Name.name,
        username: Faker::Name.name,
        email: Faker::Internet.email,
        password: Faker::Internet.password
      }
      expect(JSON(response.body)["message"]).to eq("User was created")
      expect(response).to have_http_status(:ok)
    end

    it "fails creating new user" do
      existing_user = User.first
      expect {
        post "/users", params: {
          name: existing_user.name,
          username: existing_user.username,
          email: existing_user.email,
          password: Faker::Internet.password
        }
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
