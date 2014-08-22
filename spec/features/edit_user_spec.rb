require 'rails_helper'

feature 'edit user' do
  scenario 'with valid current password' do
    user = FactoryGirl.create(:user)
    sign_in_user(user.email, user.password)

    click_link 'Account'
    click_link 'Edit Account'
    fill_in 'Current password', with: user.password
    click_button 'Update'

    expect(page).to have_content('You updated your account successfully.')
  end
end