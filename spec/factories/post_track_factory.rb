FactoryGirl.define do
  factory :post_track, :class => 'Post' do
    url (Rails.root + 'spec/support/track/RedoModernBaseball.html').to_s

    before(:create) do |post_track|
      PostCreator.create(post_track)
    end
  end
end