require 'rails_helper'

feature 'Viewing ratings' do
  let!(:post_album) { FactoryGirl.create(:post_album) }
  let(:user) { FactoryGirl.create(:user) }

  scenario 'on the post index page' do
    visit '/'
    expect(page).to have_css("div#star_#{post_album.id}")
  end

  scenario 'on a post page when logged in' do
    sign_in_user(user.email, user.password)
    visit post_path(post_album)

    expect(page).to have_css('div#star')
    expect(page).to have_css('div#user_star')
  end

  scenario 'on a post page when not logged in' do
    visit post_path(post_album)

    expect(page).to have_css('div#star')
    expect(page).to_not have_css('div#user_star')
  end
end