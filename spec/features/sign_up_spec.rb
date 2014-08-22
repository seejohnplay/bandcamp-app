require 'rails_helper'

feature 'signing up' do
  before do
    visit '/'

    click_link 'Sign up'
  end

  scenario 'with valid information' do
    fill_in 'Email', with: 'john@test.com'
    fill_in 'Name', with: 'john'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    expect(page).to have_content('A message with a confirmation link has been sent to your email address.')

    confirm_user
    expect(page).to have_content('Your account was successfully confirmed.')
  end

  scenario 'without an email' do
    fill_in 'Name', with: 'john'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    expect(page).to have_content('Email can\'t be blank')
  end

  scenario 'without a name' do
    fill_in 'Email', with: 'john@test.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    expect(page).to have_content('Name can\'t be blank')
  end

  scenario 'without a password' do
    fill_in 'Email', with: 'john@test.com'
    fill_in 'Name', with: 'john'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    expect(page).to have_content('Password can\'t be blank')
    expect(page).to have_content('Password confirmation doesn\'t match Password')
  end

  scenario 'without a matching confirmation password' do
    fill_in 'Email', with: 'john@test.com'
    fill_in 'Name', with: 'john'
    fill_in 'Password', with: 'password'
    click_button 'Sign up'

    expect(page).to have_content('Password confirmation doesn\'t match Password')
  end

  scenario 'without a password at least 8 characters in length' do
    fill_in 'Email', with: 'john@test.com'
    fill_in 'Name', with: 'john'
    fill_in 'Password', with: 'passwrd'
    fill_in 'Password confirmation', with: 'passwrd'
    click_button 'Sign up'

    expect(page).to have_content('Password is too short (minimum is 8 characters)')
  end
end