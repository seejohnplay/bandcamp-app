FactoryGirl.define do
  factory :post_album, :class => 'Post' do
    url (Rails.root + 'spec/support/album/HeadZirkusMissWalker.html').to_s

    before(:create) do |post_album|
      PostCreator.create(post_album)
    end
  end
end