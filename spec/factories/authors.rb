FactoryBot.define do
  factory :author do
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    age { Faker::Number.between(10, 80) }
  end
end
