# frozen_string_literal: true

FactoryBot.define do
  factory :skill do
    association :user
    name { 'MySkill' }
    level { 5 }
  end
end
