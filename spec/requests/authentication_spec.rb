require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  describe 'POST /auth/login' do
    before do
      create(:user, password: 'test1234')
    end

    let(:user_email) { User.first.email }
    it 'create a token' do
      post '/auth/login', params: {
        email: user_email,
        password: 'test1234'
      }
      expect(JSON(response.body)['token'].length).to_not eq(0)
    end

    it 'fails creating a token' do
      post '/auth/login', params: {
        email: Faker::Internet.email,
        password: 'test1234'
      }
      expect(JSON(response.body)['error']).to eq('unauthorized')
    end
  end
end
