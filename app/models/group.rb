# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
  has_many :messages

  # validates :users, uniqueness: { scope: :group_id }
end