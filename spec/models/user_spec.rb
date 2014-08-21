require 'rails_helper'

describe User do

  describe 'email' do
    it 'requires an email' do
      user = User.new(name: 'john', password: 'password', password_confirmation: 'password')
      user.save
      expect(user).to_not be_valid

      user.email = 'john@test.com'
      user.save
      expect(user).to be_valid
    end
  end

  describe 'name' do
    it 'requires a name' do
      user = User.new(email: 'john@test.com', password: 'password', password_confirmation: 'password')
      user.save
      expect(user).to_not be_valid

      user.name = 'john'
      user.save
      expect(user).to be_valid
    end
  end

  describe 'passwords' do
    it 'needs a password and confirmation to save' do
      user = User.new(name: 'john', email: 'john@test.com')

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
      user = User.create(name: 'john', email: 'john@test.com', password: 'password', password_confirmation: 'not_password')
      expect(user).to_not be_valid
    end
  end
end
