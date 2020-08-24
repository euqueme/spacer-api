# spec/factories/users.rb
FactoryBot.define do
    factory :user do
      email { 'bob@example.org' }
      password { 'foobar' }
      password_confirmation { 'foobar' }
    end
  end
