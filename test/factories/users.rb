FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    username { Faker::Name.first_name}
    password {Faker::Name.first_name}
  end
end
