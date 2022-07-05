require "rails_helper"
require "faker"

RSpec.describe Contexts::Users::Repository, type: :model do
  context "constructor method" do
    it "it success" do
      expect { Contexts::Users::Repository.new }.to_not raise_error
    end
  end

  context "find! method" do
    before do
      create(:user, id: 1)
    end

    it "it success" do
      expect { Contexts::Users::Repository.new.find(User.first.id) }.to_not raise_error
    end

    it "it fails" do
      expect { Contexts::Users::Repository.new.find(1000) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "find_by_email! method" do
    before do
      create(:user, email: "test@test.com")
    end

    it "it success" do
      expect { Contexts::Users::Repository.new.find_by_email("test@test.com") }.to_not raise_error
    end

    it "it fails" do
      expect(Contexts::Users::Repository.new.find_by_email("test2@test.com")).to eq(nil)
    end
  end

  context "find_by_email! method" do
    before do
      create(:user, email: "test@test.com", password: "test12345")
    end

    let(:repository) {
      Contexts::Users::Repository.new
    }

    it "it success" do
      repository.authenticate("test@test.com", password: "test12345")
      expect(repository.token).to_not eq(nil)
    end

    it "it fails" do
      repository.authenticate("test987@test.com", password: "test12345")
      expect { repository.token }.to raise_error(NoMethodError)
    end
  end

  context "find_by_email! method" do
    before do
      create(:user, email: "test3@test.com", password: "test12345")
    end

    it "it success" do
      expect(Contexts::Users::Repository.new.authenticate("test3@test.com", password: "test12345")).to_not eq(nil)
    end

    it "it fails" do
      expect(Contexts::Users::Repository.new.authenticate("test4@test.com", password: "test12345")).to eq(nil)
    end
  end

  context "create! method" do
    it "it success" do
      params = {
        name: Faker::Name.name,
        username: Faker::Name.name,
        email: Faker::Internet.email,
        password: Faker::Internet.password
      }
      event_store = Contexts::Users::Repository.new.create!(params)
      expect(event_store).to have_published(an_event(UserWasCreated))
    end
  end
end
