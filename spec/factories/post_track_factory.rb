FactoryGirl.define do
  factory :post_track, :class => 'Post' do
    url (Rails.root + 'spec/support/track/RedoModernBaseball.html').to_s

    before(:create) do |post_track|
      post_track.setup
      post_track.save
    end
  end
end