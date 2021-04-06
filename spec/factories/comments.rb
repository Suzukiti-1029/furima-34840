FactoryBot.define do
  factory :comment do
    text { Faker::Lorem.paragraph_by_chars }
    association :user
    association :item
  end
end
