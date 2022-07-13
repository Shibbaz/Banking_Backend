require 'rails_helper'
require 'faker'

RSpec.describe Contexts::Jwt::Repository, type: :model do
  context 'when object is initialized' do
    it 'it success' do
      expect { Contexts::Jwt::Repository.new }.to_not raise_error
    end
  end

  context 'when encoding jwt token' do
    before do
      create(:user, id: 1)
    end
    let(:user_id) { User.first.id }

    it 'generates token' do
      expect { Contexts::Jwt::Repository.new.jwt_encode(user_id:) }.to_not raise_error
      expect(Contexts::Jwt::Repository.new.jwt_encode(user_id:).empty?).to eql false
    end
  end

  context 'when decoding jwt token' do
    before do
      create(:user, id: 1)
    end
    subject(:repository) do
      Contexts::Jwt::Repository.new
    end
    let(:user_id) { User.first.id }
    let(:token) do
      repository.jwt_encode(user_id:)
    end

    it 'decodes token' do
      expect(repository.jwt_decode(token).empty?).to eql false
      expect(repository.jwt_decode(token)['user_id']).to eq(user_id)
    end
  end
end
