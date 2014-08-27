require 'rails_helper'

feature 'viewing posts' do
  let!(:post_album) { FactoryGirl.create(:post_album) }
  let!(:post_track) { FactoryGirl.create(:post_track) }

  before { visit '/' }

  scenario 'by listing all posts' do

    expect(page).to have_content(post_album.title)
    expect(page).to have_content(post_track.title)
  end

  scenario 'by tag' do
    click_link post_album.title
    first('.tags > a').click

    expect(page).to have_content("All Posts tagged as '#{ post_album.tags.first.name }'")
    expect(page).to have_content(post_album.title)
  end

  scenario 'individually by clicking album title' do
    click_link post_album.title

    expect(page.current_url).to eql(post_url(post_album))
    expect(page).to have_content('About The Album')
  end

  scenario 'individually by clicking track title' do
    click_link post_track.title

    expect(page.current_url).to eql(post_url(post_track))
    expect(page).to have_content('About The Track')
  end
end