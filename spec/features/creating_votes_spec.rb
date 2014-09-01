require 'rails_helper'

feature 'Creating votes' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:post_album) { FactoryGirl.create(:post_album) }

  before do
    sign_in_user(user.email, user.password)
    visit '/'
  end

  scenario 'with up and down arrow links on post index' do
    expect(page).to have_css('.vote_number', text: '0')
    click_button 'Vote up'
    expect(page).to have_css('.vote_number', text: '1')
    click_button 'Vote down'
    expect(page).to have_css('.vote_number', text: '0')
  end

  scenario 'user must be logged in to vote on posts index' do
    sign_out_user
    visit '/'
    expect(page).to_not have_button('Vote up')
    expect(page).to_not have_button('Vote down')
  end

  scenario 'with up and down arrow links on post show page' do
    click_link post_album.title

    expect(page).to have_css('.vote_number', text: '0')
    click_button 'Vote up'
    expect(page).to have_css('.vote_number', text: '1')
    click_button 'Vote down'
    expect(page).to have_css('.vote_number', text: '0')
  end

  scenario 'user must be logged in to vote on posts index' do
    sign_out_user
    visit '/'
    click_link post_album.title

    expect(page).to_not have_button('Vote up')
    expect(page).to_not have_button('Vote down')
  end
end