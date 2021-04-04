FactoryBot.define do
  factory :residence_purchase_history do
    area_number { "#{rand(1..9)}#{rand(1..9)}#{rand(1..9)}-#{rand(1..9)}#{rand(1..9)}#{rand(1..9)}#{rand(1..9)}"}
    prefecture_id { rand(2..48) }
    city {Faker::Address.city}
    address {Faker::Address.street_address}
    building {Faker::Address.building_number}
    phone_number {"#{rand(1..9)}#{rand(1..9)}#{rand(1..9)}#{rand(1..9)}#{rand(1..9)}#{rand(1..9)}#{rand(1..9)}#{rand(1..9)}#{rand(1..9)}#{rand(1..9)}#{rand(1..9)}"}
    token {"tok_abcdefghijk00000000000000000"}
  end
end
