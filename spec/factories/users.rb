FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    second_name { Faker::Name.middle_name }
    last_name { Faker::Name.last_name }
    password { Faker::Internet.password(8, 127) }

    transient do
      role { 'helper' }
    end

    after :create do |user, options|
      user.add_role(options.role) if options.role.present?
      user.remove_role(:client) if options.role.present?
      user.confirm
    end

    trait :otp_auth do
      after :create do |user|
        user.otp_required_for_login = true
        user.otp_secret = User.generate_otp_secret
        user.save
      end
    end

    trait :with_otp_code do
      after :create do |user|
        user.otp_secret = User.generate_otp_secret
        user.save
      end
    end
  end
end
