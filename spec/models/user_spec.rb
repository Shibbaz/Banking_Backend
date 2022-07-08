require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    create(:user)
  end

  it 'is valid with valid attributes' do
    expect { create(:user) }.to_not raise_error
  end

  it 'is not valid without a name' do
    expect { create(:user, name: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'is not valid without a username' do
    expect { create(:user, username: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'is not valid without a email' do
    expect { create(:user, email: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'is not valid without a password' do
    expect { create(:user, password: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'is not valid when username already exists' do
    existing_user = User.first
    expect { create(:user, username: existing_user.username) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
