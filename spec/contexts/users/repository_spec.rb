require "rails_helper"
require "faker"

RSpec.describe Contexts::Users::Repository, type: :model do
  before do
    create(:user, id: 1, email: "test3@test.com", password: "test12345")
  end

  let(:repository) {
    Contexts::Users::Repository.new
  }

  context "validates constructor method" do
    it "success" do
      expect { Contexts::Users::Repository.new }.to_not raise_error
    end
  end

  context "validates find! method" do
    it "success" do
      expect { repository.find(User.first.id) }.to_not raise_error
    end

    it "fails" do
      expect { repository.find(1000) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "validates find_by_email! method" do
    it "success" do
      expect { repository.find_by_email("test3@test.com") }.to_not raise_error
    end

    it "fails" do
      expect(repository.find_by_email("test2@test.com")).to eq(nil)
    end
  end

  context "validates token method" do
    it "success" do
      repository.authenticate("test3@test.com", password: "test12345")
      expect(repository.token).to_not eq(nil)
    end

    it "fails" do
      repository.authenticate("test987@test.com", password: "test12345")
      expect { repository.token }.to raise_error(NoMethodError)
    end
  end

  context "validates authenticate method" do
    it "is success" do
      expect(repository.authenticate("test3@test.com", password: "test12345")).to_not eq(nil)
    end

    it "fails" do
      expect(repository.authenticate("test4@test.com", password: "test12345")).to eq(nil)
    end
  end

  context "validates create! method" do
    let(:params) {
      {
        name: Faker::Name.name,
        username: Faker::Name.name,
        email: Faker::Internet.email,
        password: Faker::Internet.password
      }
    }
    it "success" do
      event_store = repository.create!(params)
      expect(event_store).to have_published(an_event(UserWasCreated))
    end
  end
end
