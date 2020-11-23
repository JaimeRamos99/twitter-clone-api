FactoryBot.define do

  factory :tweet do
    content { Faker::Lorem.paragraph }
    user
  end

end
