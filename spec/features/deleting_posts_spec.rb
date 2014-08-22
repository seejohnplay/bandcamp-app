require 'rails_helper'

feature 'deleting posts' do
  scenario 'by clicking destroy link on post index' do
    FactoryGirl.create(:post)
    visit '/'
    expect(page).to have_content('He(a)d Zirkus by Miss Walker')
    click_link 'Destroy'

    expect(page).to have_content('Post was destroyed.')

    visit '/'

    expect(page).to have_no_content('He(a)d Zirkus by Miss Walker')
  end

  scenario 'by clicking destroy link on track post index' do
    FactoryGirl.create(:post_track)
    visit '/'
    expect(page).to have_content('Re-do by Modern Baseball')
    click_link 'Destroy'

    expect(page).to have_content('Post was destroyed.')

    visit '/'

    expect(page).to have_no_content('Re-do by Modern Baseball')
  end
end