FactoryBot.define do
  factory :admin_user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    password { "Password!" }
    password_confirmation { "Password!" }
  end

  factory :authorization do
    provider { "google_oauth2" }
    sequence(:uid)
    association :admin_user, factory: :admin_user
  end

  factory :appreciable_user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
  end

  factory :appreciation do
    association :by, factory: :appreciable_user
    to { [FactoryBot.create(:appreciable_user)] }
    message { Faker::Markdown.sandwich(sentences: 3) }
  end
end
