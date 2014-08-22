module UserHelpers
  def confirm_user
    token = extract_confirmation_token(last_email)
    visit "users/confirmation?confirmation_token=#{token}"
  end

  def sign_in_user(user_email, user_password)
    visit '/'
    click_link 'Sign in'
    fill_in 'Email', with: user_email
    fill_in 'Password', with: user_password
    click_button 'Sign in'
  end
end

RSpec.configure do |c|
  c.include UserHelpers, type: :feature
end