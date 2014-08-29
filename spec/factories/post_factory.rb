FactoryGirl.define do
  factory :post_album, :class => 'Post' do
    url (Rails.root + 'spec/support/album/HeadZirkusMissWalker.html').to_s
  end

  factory :post_track, :class => 'Post' do
    url (Rails.root + 'spec/support/track/RedoModernBaseball.html').to_s
  end

  before(:create) { |post| PostCreator.create(post) }
end