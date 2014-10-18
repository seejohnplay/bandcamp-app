FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@test.com" }
  sequence(:username) { |n| "username#{n}" }

  factory :user do
    email { generate(:email) }
    username { generate(:username) }
    password 'password'
    password_confirmation 'password'

    after(:create) { |user| user.confirm! }
  end
end