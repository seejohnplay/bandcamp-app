require 'rails_helper'

 feature 'creating posts' do
   before do
     visit '/'
     click_link 'Submit new post'
   end

   scenario 'with valid url' do
     fill_in 'Bandcamp URL', with: (Rails.root + 'spec/support/album/HeadZirkusMissWalker.html').to_s
     click_button 'Submit the URL!'

     expect(page).to have_content('Post was successfully created.')
     expect(page).to have_content('He(a)d Zirkus by Miss Walker')
   end

   scenario 'with invalid url' do
     fill_in 'Bandcamp URL', with: 'http://invalid.url'
     click_button 'Submit the URL!'

     expect(page).to have_content('Something went wrong. Please make sure you\'re submitting a valid Bandcamp URL containing playable audio.')
   end

   scenario 'with the same valid url twice' do
     fill_in 'Bandcamp URL', with: (Rails.root + 'spec/support/album/HeadZirkusMissWalker.html').to_s
     click_button 'Submit the URL!'

     expect(page).to have_content('Post was successfully created.')

     click_link 'Submit new post'
     fill_in 'Bandcamp URL', with: (Rails.root + 'spec/support/album/HeadZirkusMissWalker.html').to_s
     click_button 'Submit the URL!'

     expect(page).to have_content('Embed code has already been imported.')
   end
 end