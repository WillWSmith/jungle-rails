require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        first_name: 'Test',
        last_name: 'User',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).to be_valid
    end

    it 'is not valid without a password' do
      user = User.new(
        first_name: 'Test',
        last_name: 'User',
        email: 'test@example.com',
        password: nil,
        password_confirmation: nil
      )
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Password can't be blank")
    end

    it 'is valid without password confirmation' do
      user = User.new(
        first_name: 'Test',
        last_name: 'User',
        email: 'test@example.com',
        password: 'password'
        # Omitting password_confirmation
      )
      expect(user).to be_valid
    end

    it 'is not valid when password and password confirmation do not match' do
      user = User.new(
        first_name: 'Test',
        last_name: 'User',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'differentpassword'
      )
      expect(user).not_to be_valid
    end

    it 'is not valid without an email' do
      user = User.new(
        first_name: 'Test',
        last_name: 'User',
        email: nil,
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Email can't be blank")
    end

    it 'is not valid without a first name' do
      user = User.new(
        first_name: nil,
        last_name: 'User',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("First name can't be blank")
    end

    it 'is not valid without a last name' do
      user = User.new(
        first_name: 'Test',
        last_name: nil,
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Last name can't be blank")
    end

    it 'is not valid with a duplicate email (case insensitive)' do
      User.create!(
        first_name: 'Existing',
        last_name: 'User',
        email: 'test@example.com'.downcase,
        password: 'password',
        password_confirmation: 'password'
      )
      user = User.new(
        first_name: 'Test',
        last_name: 'User',
        email: 'TEST@EXAMPLE.COM'.downcase,
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Email has already been taken")
    end

    it 'is not valid with a password shorter than 6 characters' do
      user = User.new(
        first_name: 'Test',
        last_name: 'User',
        email: 'test@example.com',
        password: 'short',
        password_confirmation: 'short'
      )
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
    end
  end

  describe '.authenticate_with_credentials' do
    before :each do
      @user = User.create!(
        first_name: 'Test',
        last_name: 'User',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
    end

    it 'authenticates with valid credentials' do
      authenticated_user = User.authenticate_with_credentials('test@example.com', 'password')
      expect(authenticated_user).to eq(@user)
    end

    it 'does not authenticate with invalid credentials' do
      authenticated_user = User.authenticate_with_credentials('test@example.com', 'wrongpassword')
      expect(authenticated_user).to be_nil
    end

    it 'authenticates with email having leading/trailing spaces' do
      authenticated_user = User.authenticate_with_credentials('  test@example.com  ', 'password')
      expect(authenticated_user).to eq(@user)
    end

    it 'authenticates with email in different case' do
      authenticated_user = User.authenticate_with_credentials('TEST@EXAMPLE.COM', 'password')
      expect(authenticated_user).to eq(@user)
    end
  end
end



