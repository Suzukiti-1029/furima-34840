FactoryBot.define do
  factory :item do
    name {Faker::Lorem.word }
    describe {Faker::Lorem.paragraph_by_chars}
    category_id {rand(2..11)}
    situation_id {rand(2..7)}
    fare_option_id {rand(2..3)}
    prefecture_id {rand(2..48)}
    need_days_id {rand(2..4)}
    fee {rand(300..9999999)}
    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test_img.png'), filename: 'test_img.png')
    end
  end
end
