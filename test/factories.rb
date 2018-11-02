FactoryBot.define do
  factory :admin_user do
    sequence(:name) { |n| "AdminUser Name #{n}" }
    sequence(:email) { |n| "email#{n}@email.com" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :authorization do
    provider { "google_oauth2" }
    sequence(:uid)
    association :admin_user, factory: :admin_user
  end
end
