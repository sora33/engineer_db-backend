# frozen_string_literal: true

FactoryBot.define do
  factory :group_user do
    group
    user
  end
end
