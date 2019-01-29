FactoryBot.define do
  factory :promote do
    title { Faker::Creature::Cat.name }
    text { Faker::TvShows::FamilyGuy.quote }
  end
end
