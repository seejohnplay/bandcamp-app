require 'rails_helper'

describe User do

  describe 'email' do
    it 'requires an email' do
      user = User.new(username: 'john', password: 'password', password_confirmation: 'password')
      user.save
      expect(user).to_not be_valid

      user.email = 'john@test.com'
      user.save
      expect(user).to be_valid
    end

    it 'requires an email to be unique' do
      user = User.new(username: 'john', email: 'john@test.com', password: 'password', password_confirmation: 'password')
      user.save
      expect(user).to be_valid

      another_user = User.new(username: 'john2', email: 'john@test.com', password: 'password', password_confirmation: 'password')
      another_user.save
      expect(another_user).to_not be_valid
    end
  end

  describe 'username' do
    it 'requires a username' do
      user = User.new(email: 'john@test.com', password: 'password', password_confirmation: 'password')
      user.save
      expect(user).to_not be_valid

      user.username = 'john'
      user.save
      expect(user).to be_valid
    end

    it 'requires a username to be at least 2 characters in length' do
      user = User.new(username: 'a', email: 'john@test.com', password: 'password', password_confirmation: 'password')
      user.save
      expect(user).to_not be_valid

      user.username = 'aa'
      user.save
      expect(user).to be_valid
    end

    it 'requires a username is only made up of numbers, letters and underscores' do
      user = User.new(username: 'john%', email: 'john@test.com', password: 'password', password_confirmation: 'password')
      user.save
      expect(user).to_not be_valid

      user.username = 'john_'
      user.save
      expect(user).to be_valid
    end

    it 'requires a username to be unique' do
      user = User.new(username: 'john', email: 'john@test.com', password: 'password', password_confirmation: 'password')
      user.save
      expect(user).to be_valid

      another_user = User.new(username: 'john', email: 'john@test.com', password: 'password', password_confirmation: 'password')
      another_user.save
      expect(another_user).to_not be_valid
    end
  end

  describe 'passwords' do
    it 'needs a password and confirmation to save' do
      user = User.new(username: 'john', email: 'john@test.com')

      user.save
      expect(user).to_not be_valid

      user.password = 'password'
      user.password_confirmation = ''
      user.save
      expect(user).to_not be_valid

      user.password_confirmation = 'password'
      user.save
      expect(user).to be_valid
    end

    it 'needs password and password confirmation to match' do
      user = User.create(username: 'john', email: 'john@test.com', password: 'password', password_confirmation: 'not_password')
      expect(user).to_not be_valid
    end
  end

  describe 'roles' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'assigns first user role to admin by default' do
      expect(user.admin?).to be true
      expect(user.role).to eql('admin')
    end

    it 'assigns all other user\'s role to contributor by default' do
      another_user = FactoryGirl.create(:user)

      expect(another_user.admin?).to be false
      expect(another_user.contributor?).to be true
      expect(another_user.role).to eql('contributor')
    end
  end
end