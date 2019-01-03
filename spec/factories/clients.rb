FactoryBot.define do
  factory :client do
    name { Faker::TvShows::FamilyGuy.character }
    address { Faker::Address.full_address }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number[2..-1] }
    promotion { Faker::Boolean.boolean }
    first_contact { Faker::Boolean.boolean }
  end
end
