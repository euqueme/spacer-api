# spec/factories/users.rb
FactoryBot.define do
    factory :user do
      email { Faker::Internet.email }
      password { 'foobar' }
    end
  end