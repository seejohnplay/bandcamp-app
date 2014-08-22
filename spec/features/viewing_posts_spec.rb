require 'rails_helper'

feature 'viewing posts' do
  let!(:post) { FactoryGirl.create(:post) }
  let!(:post_track) { FactoryGirl.create(:post_track) }

  before { visit '/' }

  scenario 'by listing all posts' do

    expect(page).to have_content(post.title)
    expect(page).to have_content(post_track.title)
  end

  scenario 'individually by clicking album title' do
    click_link post.title

    expect(page.current_url).to eql(post_url(post))
    expect(page).to have_content('About The Album')
  end

  scenario 'individually by clicking track title' do
    click_link post_track.title

    expect(page.current_url).to eql(post_url(post_track))
    expect(page).to have_content('About The Track')
  end
end