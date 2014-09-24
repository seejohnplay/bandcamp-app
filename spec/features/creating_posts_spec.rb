require 'rails_helper'

feature 'creating posts' do
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in_user(user.email, user.password)
    visit '/'
    click_link 'Submit new post'
  end

  scenario 'with valid url' do
    fill_in 'post_url', with: (Rails.root + 'spec/support/album/HeadZirkusMissWalker.html').to_s
    click_button 'Submit the URL!'

    expect(page).to have_content('Post was successfully created.')
    expect(page).to have_content('He(a)d Zirkus by Miss Walker')
  end

  scenario 'with invalid url' do
    fill_in 'post_url', with: 'http://invalid.url'
    click_button 'Submit the URL!'

    expect(page).to have_content('Something went wrong. Please make sure you\'re submitting a valid Bandcamp or Soundcloud URL containing playable audio.')
  end

  scenario 'with the same valid url twice' do
    fill_in 'post_url', with: (Rails.root + 'spec/support/album/HeadZirkusMissWalker.html').to_s
    click_button 'Submit the URL!'

    expect(page).to have_content('Post was successfully created.')

    click_link 'Submit new post'
    fill_in 'post_url', with: (Rails.root + 'spec/support/album/HeadZirkusMissWalker.html').to_s
    click_button 'Submit the URL!'

    expect(page).to have_content('Embed code has already been imported.')
  end

  scenario 'user must be signed in to create post' do
    sign_out_user
    visit '/'
    expect(page).to_not have_content 'Submit new post'
  end
end