require 'rails_helper'

feature 'Searching' do
  scenario 'for a valid artist name' do
    FactoryGirl.create(:post_album)

    visit '/'
    fill_in 'search[term]', with: 'Miss Walker'
    click_button 'Search'

    expect(page).to have_content 'He(a)d Zirkus by Miss Walker'
  end
end