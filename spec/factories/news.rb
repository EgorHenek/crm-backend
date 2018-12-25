FactoryBot.define do
  factory :news do
    title {Faker::TvShows::FamilyGuy.character}
    description {Faker::TvShows::FamilyGuy.quote}
    published_at {Time.now}
    user
  end
end
