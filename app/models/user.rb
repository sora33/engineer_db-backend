# frozen_string_literal: true

class User < ApplicationRecord
  has_many :skills, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :messages, dependent: :destroy

  has_one_attached :avatar

  validates :provider, :provider_id, :name, presence: true
  validates :location, :purpose, :comment, :work, :occupation,
            :gender, length: { maximum: 25 }, allow_blank: true
  validates :website, length: { maximum: 200 }, allow_blank: true
  validates :hobby, :introduction, length: { maximum: 600 }, allow_blank: true
  validates :experience, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_blank: true

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

  def self.filter_and_sort(params, current_user)
    users = includes(:skills, :avatar_attachment).where.not(id: current_user.id).order(last_sign_in_at: :desc)
    users = apply_search_params(users, params.slice(:gender, :location, :purpose, :work, :occupation))
    apply_skill_params(users, params.slice(:skill, :skillLevel))
  end

  def self.apply_search_params(users, search_params)
    search_params.each do |key, value|
      users = users.where(key => value) if value.present?
    end
    users
  end

  def self.apply_skill_params(users, skill_params)
    skill = skill_params[:skill]
    skill_level = skill_params[:skillLevel]
    if skill.present? && skill_level.present?
      users = users.joins(:skills).where('skills.name = ? AND skills.level >= ?', skill, skill_level)
    end
    users
  end

  def update_skills(skill_attributes)
    ActiveRecord::Base.transaction do
      skill_attributes.each do |skill_param|
        skill = skills.find_or_initialize_by(name: skill_param[:name])
        skill.update!(level: skill_param[:level])
      end
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, "Failed to update skills: #{e.record.errors.full_messages.join(', ')}")
    false
  end

  def self.authenticate_from_token(decoded_token)
    find_by(provider: decoded_token['provider'], id: decoded_token['id']).tap do |user|
      user&.update_last_sign_in
    end
  end

  def update_last_sign_in
    update(last_sign_in_at: Time.zone.now) if last_sign_in_at.nil? || last_sign_in_at < 10.minutes.ago
  end
end
