# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    provider { 'test_provider' }
    sequence(:provider_id) { |n| "provider_id_#{n}" }
    sequence(:name) { |n| "Test User #{n}" }
    purpose { User::PURPOSE_OPTIONS.sample }
    comment { 'This is a test comment.' }
    work { User::WORK_OPTIONS.sample }
    occupation { User::OCCUPATION_OPTIONS.sample }
    gender { %w[male female].sample }
    experience { rand(1..10) }
    introduction { 'This is a test introduction.' }
    hobby { 'This is a test hobby.' }
    birthday { 30.years.ago }
    location { 'Test Location' }
    website { 'https://testwebsite.com' }
    last_sign_in_at { Time.zone.now }
  end
end
