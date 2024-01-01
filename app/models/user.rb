# frozen_string_literal: true

class User < ApplicationRecord
  has_many :skills, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_one_attached :avatar

  validates :provider, :provider_id, :name, presence: true

  PURPOSE_OPTIONS = %w[partner work hobby other].freeze
  OCCUPATION_OPTIONS = %w[engineer projectManager consultant dataAnalyst cto other].freeze
  WORK_OPTIONS = %w[fullTime freelancer businessOwner student other].freeze

  # rubocop:disable Metrics/AbcSize
  def self.age_distribution
    now = Time.zone.now
    {
      under_20_years: count_for_age(now - 20.years, nil),
      '20_29_years': count_for_age(now - 29.years, now - 20.years),
      '30_39_years': count_for_age(now - 39.years, now - 30.years),
      '40_49_years': count_for_age(now - 49.years, now - 40.years),
      '50_59_years': count_for_age(now - 59.years, now - 50.years),
      '60_69_years': count_for_age(now - 69.years, now - 60.years),
      over_70_years: count_for_age(nil, now - 70.years)
    }
  end
  # rubocop:enable Metrics/AbcSize

  def self.count_for_age(from_age, to_age)
    query = all
    query = query.where('birthday > ?', from_age) if from_age
    query = query.where('birthday <= ?', to_age) if to_age
    query.count
  end

  def self.distribution(attribute, options)
    counts = group(attribute).count
    options.index_with { |option| counts[option] || 0 }
  end

  def self.purpose_distribution
    distribution(:purpose, PURPOSE_OPTIONS)
  end

  def self.occupation_distribution
    distribution(:occupation, OCCUPATION_OPTIONS)
  end

  def self.work_distribution
    distribution(:work, WORK_OPTIONS)
  end
end
