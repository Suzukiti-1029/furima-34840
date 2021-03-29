FactoryBot.define do
  factory :user do
    nickname { Faker::Name.initials }
    email { Faker::Internet.free_email }
    password { Faker::Internet.password(min_length: 6).downcase + '1' + 'a' }
    password_confirmation { password }
    last_name { 'あア亜' }
    first_name { 'いイ井' }
    last_name_detail { 'アアア' }
    first_name_detail { 'イイイ' }
    birthday { '2000-01-01' }
  end
end
