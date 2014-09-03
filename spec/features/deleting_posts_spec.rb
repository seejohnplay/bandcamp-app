require 'rails_helper'

feature 'deleting posts' do
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in_user(user.email, user.password)
    user.admin!
  end

  scenario 'by clicking destroy link on post index' do
    FactoryGirl.create(:post_album)
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

  scenario 'user must be signed in to delete post' do
    FactoryGirl.create(:post_album)
    sign_out_user
    visit '/'
    expect(page).to_not have_link('Destroy')
  end

  scenario 'user must be an admin to delete post' do
    FactoryGirl.create(:post_track)
    user.contributor!
    visit '/'
    expect(page).to_not have_link('Destroy')

    user.reader!
    visit '/'
    expect(page).to_not have_link('Destroy')

    user.admin!
    visit '/'
    expect(page).to have_link('Destroy')
  end
end