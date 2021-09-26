FactoryBot.define do
  factory :category do
    name { Faker::Color.color_name }
  end
end
