# frozen_string_literal: true

class Skill < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :level, presence: true
  validates :name, uniqueness: { scope: :user_id }
  validates :level, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 7 }
  validates :level, numericality: { only_integer: true }
end
