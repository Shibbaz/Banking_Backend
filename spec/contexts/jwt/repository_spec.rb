require "rails_helper"
require "faker"

RSpec.describe Contexts::Jwt::Repository, type: :model do
  context "constructor method" do
    it "it success" do
      expect { Contexts::Jwt::Repository.new }.to_not raise_error
    end
  end

  context "jwt_encode method" do
    before do
      create(:user, id: 1)
    end

    it "it generates token" do
      expect { Contexts::Jwt::Repository.new.jwt_encode(user_id: User.first.id) }.to_not raise_error
      expect(Contexts::Jwt::Repository.new.jwt_encode(user_id: User.first.id).empty?).to eql false
    end
  end

  context "jwt_encode method" do
    before do
      create(:user, id: 1)
    end
    let(:repository) {
      Contexts::Jwt::Repository.new
    }
    let(:token) {
      repository.jwt_encode(user_id: User.first.id)
    }

    it "it decodes token, returns an user" do
      expect(repository.jwt_decode(token).empty?).to eql false
      expect(repository.jwt_decode(token)["user_id"]).to eq(User.first.id)
    end
  end
end
