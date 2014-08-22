require 'rails_helper'

feature 'signing in' do
  let(:user) { FactoryGirl.create(:user) }

  scenario 'with valid email and password' do
    sign_in_user(user.email, user.password)

    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'with invalid email' do
    sign_in_user('invalid@email.com', user.password)

    expect(page).to have_content('Invalid email or password.')
  end

  scenario 'with invalid password' do
    sign_in_user(user.email, 'invalid_password')

    expect(page).to have_content('Invalid email or password.')
  end

  scenario 'with invalid email and password' do
    sign_in_user('invalid@email.com', 'invalid_password')

    expect(page).to have_content('Invalid email or password.')
  end
end