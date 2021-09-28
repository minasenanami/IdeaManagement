FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "#{n}_#{Faker::Color.color_name}" }
  end
end
