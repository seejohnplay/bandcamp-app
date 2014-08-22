FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@test.com"}
  sequence(:name) { |n| "name#{n}"}

  factory :user do
    name { generate(:name) }
    email { generate(:email) }
    password 'password'
    password_confirmation 'password'

    after(:create) { |user| user.confirm! }
  end
end