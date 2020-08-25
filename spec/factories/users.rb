# spec/factories/users.rb
FactoryBot.define do
    factory :user do
      email { Faker::Internet.email }
      password { 'foobar' }
      activated { true }
      activated_at { Time.zone.now }
    end
  end
