FactoryGirl.define do
  factory :post do
    url (Rails.root + 'spec/support/album/HeadZirkusMissWalker.html').to_s

    before(:create) do |post|
      post.setup
      post.save
    end
  end
end