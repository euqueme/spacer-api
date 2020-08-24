# spec/factories/users.rb
FactoryBot.define do
    factory :user do
      email { generate(:email) }
      password { 'foobar' }
    end
  end