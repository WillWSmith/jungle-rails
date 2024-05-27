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
end



