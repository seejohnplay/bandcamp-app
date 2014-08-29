require 'rails_helper'

feature 'Searching' do
  let!(:post_album) { FactoryGirl.create(:post_album) }

  scenario 'for a valid artist name' do
    visit '/'
    fill_in 'search[term]', with: post_album.artist
    click_button 'Search'

    expect(page).to have_content("All Posts matching '#{ post_album.artist }'")
    expect(page).to have_content "#{post_album.title} by #{post_album.artist}"
  end
end