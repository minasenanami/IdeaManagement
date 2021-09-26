FactoryBot.define do
  factory :idea do
    category
    body { Faker::Lorem.characters(number: 10) }
  end
end
