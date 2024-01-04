# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    content { Faker::Lorem.sentence }
    group
    user
  end
end
